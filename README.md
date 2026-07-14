# README

This README would normally document whatever steps are necessary to get the
application up and running.

## Tests

RSpec is configured for this Rails app. Prepare the test database and run the suite with:

```sh
RAILS_ENV=test TEST_DATABASE_URL=postgresql://localhost/short_link_test bin/rails db:prepare
TEST_DATABASE_URL=postgresql://localhost/short_link_test bundle exec rspec
```

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
