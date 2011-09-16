rnews [Build Status](https://secure.travis-ci.org/charliesome/rnews.png)
=====

You'll need to create the files below to run this app.

## `config/database.yml`

    production:
      adapter: mysql2
      host: localhost
      user: root
      database: rnews
      pool: 5
      timeout: 5000

## `config/initializers/secret_token.rb`

    Rnews::Application.config.secret_token = 'fill this with some really really really really really long secret token'

