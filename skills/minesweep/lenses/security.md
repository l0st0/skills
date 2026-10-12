# Security lens: the boundaries the change touches

Trust follows who **wrote** a value, not which channel delivered it: a request body, a URL parameter, a cookie, a file name, a webhook, a third-party API response, another process's arguments and an LLM's output were all written by someone outside your control.

## 1. Threat-model the touched boundaries

List every boundary the diff adds or changes: where untrusted data enters, and which asset sits behind it (credentials, personal data, another tenant's records, admin actions, money, storage). For each, ask the STRIDE questions and keep only the ones with a concrete answer in this diff:

- **Spoofing**: can a caller act as someone else?
- **Tampering**: can a caller change a value the server trusts (an id, an owner, a price, a role)?
- **Repudiation**: can a sensitive act happen with no audit record?
- **Information disclosure**: can a caller read data, or learn a fact (an account exists, a record exists), they should not?
- **Denial of service**: can a caller make the server do unbounded work?
- **Elevation of privilege**: can a caller gain a capability their role lacks?

The repo's ADRs and glossary often define the intended model (who may do what, which errors must stay generic); measure each finding against it.

## 2. Walk the controls the diff touches

**Authorization on the exact record.** Authentication is not authorization. Every handler that reads or writes a record checks that this caller may act on this record, loaded server-side, not on an id, owner or role the client supplied. A check on one record followed by a write to another is the classic IDOR. When the repo has its own authorization mechanism (a policy module, proof types, middleware), the new code goes through it.

**Unauthenticated and public surfaces.** Anything reachable without a session: the record id is the only secret, so it must be unguessable; the response carries only fields meant for the public; a not-found and a not-allowed answer look the same.

**Input at the boundary.** Every external input is parsed by a schema (shape, lengths, enums, formats) before use; downstream code uses only the parsed value. Client-side validation is UX, never a control.

**Injection and output.** Queries are parameterized or built by the ORM's API, never by concatenating input. HTML goes through the framework's escaping; any raw-HTML sink (`dangerouslySetInnerHTML`, `innerHTML`, `v-html`) gets an allowlist sanitizer. No input reaches `eval`, a shell, or a file path unchecked.

**Errors and responses.** Error bodies are generic; stack traces, provider errors and internal ids stay in server logs. Serialized errors carry no `cause` from a third party. Responses strip fields the caller has no use for (hashes, tokens, other users' data).

**Sessions and auth flows.** Cookies are `httpOnly`, `secure`, `sameSite`; tokens are single-use and expire; sign-in and recovery flows give one generic answer whether or not the account exists; auth endpoints are rate-limited by a store shared across instances.

**Uploads and storage.** Allowlist the content type, cap the size, check the bytes when it matters; the extension proves nothing. Storage keys are generated server-side and bound to their owner, so a caller cannot read or overwrite another's object by naming its key.

**Outbound fetches (SSRF).** A URL the caller influences is allowlisted by scheme and host, resolves to no private or link-local address, and does not follow redirects.

**Destructive operations on derived targets.** A delete, move or overwrite whose target comes from input is checked against an allowlisted root, at least one level below it, with ownership established before the act.

**Secrets.** Secrets come from the environment or a secret store; none appear in the diff, in logs, in client bundles (watch env vars the bundler exposes to the browser), or in error reports.

**Personal data.** New personal fields have a purpose, reach no analytics or third party without a stated reason, and are covered by the existing deletion path. Logs and telemetry carry ids, not personal data.

**LLM features.** Model output is untrusted input: validate it against a schema before it reaches a query, the DOM, a shell or a path. Permissions are enforced in code, not in the prompt; the context window holds no secrets or other tenants' data.

**New dependencies.** For each added package: is it the intended name (typosquats), maintained, and free of install scripts nobody reviewed? The lockfile diff contains only what the manifest change explains.

## Severity

Severity follows the brief. Two readings specific to this lens: a control missing where exploitation needs a second mistake is `should-fix`, and so is a leak of a fact (an account exists) rather than data.
