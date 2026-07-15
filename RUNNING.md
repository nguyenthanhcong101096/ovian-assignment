# Running the Assignment

## Prerequisites

- Docker and Docker Compose

## Run Locally With Docker

Start the Rails API and PostgreSQL:

```sh
RAILS_MASTER_KEY='6e6a75087a9067cdccc0b882ba6a222d' docker compose up --build
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
  "short_url": "http://localhost:3000/s/abc1234"
}
```

### Decode URL

Use the `short_url` returned by the encode endpoint:

```sh

curl --get "$BASE_URL/api/v1/decode" \
  --data-urlencode "short_url=http://localhost:3000/s/abc1234"
```

Example response:

```json
{
  "original_url": "https://codesubmit.io/library/react"
}
```

## Call The API On Heroku

```sh
BASE_URL=https://short-link-bcec94c612a4.herokuapp.com
```

Encode URL:

```sh
curl -X POST "$BASE_URL/api/v1/encode" \
  -d "original_url=https://codesubmit.io/library/react"
```

Example Heroku response:

```json
{
  "short_url": "https://short-link-bcec94c612a4.herokuapp.com/s/ojROB4y"
}
```

Decode URL:

```sh
curl --get "$BASE_URL/api/v1/decode" \
  --data-urlencode "short_url=https://short-link-bcec94c612a4.herokuapp.com/s/ojROB4y"
```
Example Heroku response:

```json
{
  "original_url": "https://codesubmit.io/library/react"
}
```