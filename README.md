# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Tests

RSpec is configured for this Rails app. Prepare the test database and run the suite with:

```sh
RAILS_ENV=test TEST_DATABASE_URL=postgresql://localhost/short_link_test bin/rails db:prepare
TEST_DATABASE_URL=postgresql://localhost/short_link_test bundle exec rspec
```

## Docker

Run the production Docker image locally with Postgres:

```sh
RAILS_MASTER_KEY="$(cat config/credentials/production.key)" docker compose up --build
```

The API will be available at `http://localhost:3000`.

To run one-off Rails commands in the container:

```sh
docker compose run --rm web ./bin/rails db:prepare
```

## Heroku Docker deploy

Heroku uses `Dockerfile` and `heroku.yml`. `docker-compose.yml` is only for
local runs.

```sh
heroku login
heroku create <app-name>
heroku stack:set container --app <app-name>
heroku addons:create heroku-postgresql:<plan> --app <app-name>
heroku config:set RAILS_MASTER_KEY="$(cat config/credentials/production.key)" --app <app-name>
git push heroku main
```

If the Heroku app already exists, only run `heroku stack:set container` once.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
