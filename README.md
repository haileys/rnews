rnews 
=====

## Cool Stuff:

#### CI
![Build Status](https://secure.travis-ci.org/charliesome/rnews.png)

#### Test Coverage:
http://news.charlie.bz/coverage

## Installation:

You'll need to create the files below to run this app.

### config/database.yml

    production:
      adapter: mysql2
      host: localhost
      user: root
      database: rnews
      pool: 5
      timeout: 5000

### config/app_config.yml

    name: rnews
	secret_token: some really really long secret token
