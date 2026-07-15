# Short Link API

Rails API for creating and resolving short links.

See [RUNNING.md](RUNNING.md) for detailed instructions on how to run and use
the assignment.

## Tech Stack

- Ruby 3.3.5
- Rails 8.0.5
- PostgreSQL via `pg`
- Puma 8.0.2
- Docker and Docker Compose
- RSpec for request/model/validator specs
- Hashids for short code generation
- Rack::Attack for request rate limiting

## Completed Checklist

- [x] Implement `POST /api/v1/encode` to create a short URL from an original URL.
- [x] Implement `GET /api/v1/decode` to return the original URL from a short URL.
- [x] Implement `GET /s/:code` to redirect users to the original URL.


## Persistence

Short-link mappings are persisted in PostgreSQL rather than application memory.
Restarting the Rails application does not remove previously generated links,
and existing short URLs can still be resolved after the application starts
again.

## Collision Strategy

Short codes are generated from the database primary key using Hashids. Since the
primary key is unique, each generated code should also be unique for the same
salt and alphabet. The database also enforces a unique index on
`short_links.code` as a final safety check.

If the implementation later switches to random codes, it should keep the unique
index and add retry-on-collision logic.

## Cache Strategy

The read path can be cached by storing the mapping from `code` to
`original_url`, for example `short_link:GeAi9K -> https://codesubmit.io/library/react`. This
reduces repeated database reads for popular short links on `/api/v1/decode` or
`/s/:code`.

Since short links are effectively immutable, cached
values can use a long TTL.

## Database Growth

Every valid `POST /api/v1/encode` request creates a new `short_links` record, so
the database grows with usage. As the table becomes larger, storage, backups,
migrations, and query performance can become more expensive.

Mitigations:
- Rate limit link creation.
- Monitor database size and row count.
- Keep indexes on lookup fields such as `code`.
- Consider expiration or cleanup for old/unused links if the product allows it.

## Security Considerations

### Abuse / DoS via `POST /api/v1/encode`

The encode endpoint is public and creates a database record for every valid
`original_url`. Without authentication or rate limiting, an attacker can send a
large number of requests to create many short links, increasing database size
and consuming application resources.

Mitigations:

- Rate limit link creation per IP with Rack::Attack.
- Add API authentication if the endpoint should not be fully public.
- Monitor request volume and database growth.
- Consider cleanup or expiration for unused/old short links if the service is
  public.

### Short Code Enumeration

Short codes are generated from the primary key using Hashids. This avoids
collisions because each database ID is unique, but it is still obfuscation
rather than cryptographic security. If the salt is leaked or the pattern is
abused, attackers may try to enumerate valid short codes.

Mitigations:

- Keep `hashid_salt` secret in Rails credentials.
- Rate limit decode/redirect endpoints.
- Monitor repeated requests for invalid short codes.
- Use longer random codes if stronger anti-enumeration guarantees are required.

### Malicious Destination / Phishing Abuse

Short links can redirect users to any submitted `original_url`. Attackers can
create links to phishing or scam pages, such as fake bank login pages, while
using this service's domain to make the URL look more trustworthy.

Mitigations:

- Block known malicious domains.
- Monitor and remove reported malicious links.
- Consider showing a warning page before redirecting users to the destination.

## AI Usage Disclosure

AI was used as a discussion and review tool for project structure, design
trade-offs, security considerations, scalability considerations

The final implementation, debugging, testing, and engineering decisions were
completed and verified by me.
