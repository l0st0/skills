# Performance lens: what grows with the data

Flag only what the diff itself shows. A performance finding names the input that grows (rows, users, items in a list, bytes) and what grows with it. A suspicion without that is a `consider` with a measurement attached, never a `blocker`.

## Backend

- **N+1** queries, fetches or API calls.
- **Unbounded reads**: a list query or endpoint with no limit, or a stable order missing under pagination. Every collection the user can grow is bounded.
- **Query shape vs indexes**: a new filter, join or sort on a column with no index behind it, on a table that grows. Suggest the index and the plan check (`EXPLAIN`) that would confirm it.
- **Work on the request path** that belongs elsewhere: a heavy computation, a slow third-party call awaited before the response, sequential awaits that could run in parallel.
- **Caching**: every input that changes the response (user, tenant, locale, permissions) is in the key, or one viewer's data is served to another: that is a security `blocker`, not a performance note. Invalidation is stated. Fresh-only data (permissions, balances) is not cached.

## Frontend

- **Waterfalls**: a fetch that waits on an earlier one it does not depend on.
- **Bundle**: a new heavy dependency imported on a route that does not need it up front; it belongs behind a lazy boundary.
- **Images**: missing `width`/`height` (layout shift), the largest above-the-fold image loaded lazily, unoptimized formats or sizes.
- **Renders**: a large list rendered without windowing, or new objects and functions created in render and passed to memoized children, where the diff shows that list or child.
