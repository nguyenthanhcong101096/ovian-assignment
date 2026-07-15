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

### Open Redirect / Phishing Risk

Short links can redirect users to any submitted `original_url`. Attackers can
create links to phishing or scam pages, such as fake bank login pages, while
using this service's domain to make the URL look more trustworthy.

Mitigations:

- Block known malicious domains.
- Monitor and remove reported malicious links.
- Consider showing a warning page before redirecting users to the destination.
