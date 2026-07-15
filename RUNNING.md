# Running the Assignment

## Prerequisites

- Docker and Docker Compose

## Run Locally With Docker

Start the Rails API and PostgreSQL:

```sh
RAILS_MASTER_KEY="$(cat config/credentials/production.key)" docker compose up --build
```

The local API runs at:

```sh
BASE_URL=http://localhost:3000
```

## Call The API Locally

### Encode URL

Create a short URL from an HTTP/HTTPS URL:

```sh
curl -X POST "$BASE_URL/api/v1/encode" \
  -d "original_url=https://codesubmit.io/library/react"
```

Example response:

```json
{
  "short_url": "https://localhost:3000/s/abc1234"
}
```

### Decode URL

Use the `short_url` returned by the encode endpoint:

```sh
SHORT_URL=https://localhost:3000/s/abc1234

curl --get "$BASE_URL/api/v1/decode" \
  --data-urlencode "short_url=$SHORT_URL"
```

Example response:

```json
{
  "original_url": "https://codesubmit.io/library/react"
}
```

## Call The API On Heroku

If the app is already deployed to Heroku, set `BASE_URL` and `SHORT_URL` with
the Heroku app host:

```sh
BASE_URL=https://<app-name>.herokuapp.com
SHORT_URL=https://<app-name>.herokuapp.com/s/abc1234
```

Encode URL:

```sh
curl -X POST "$BASE_URL/api/v1/encode" \
  -d "original_url=https://codesubmit.io/library/react"
```

Example Heroku response:

```json
{
  "short_url": "https://<app-name>.herokuapp.com/s/abc1234"
}
```

Decode URL:

```sh
curl --get "$BASE_URL/api/v1/decode" \
  --data-urlencode "short_url=$SHORT_URL"
```
