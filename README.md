# README

onto-mongo is an ontology mapping/querying application for mongoDB that parses SPARQL queries and uses a mapping to access a mongoDB database, using Ruby on Rails and ActiveModel.

* Ruby version
ruby 2.3.0
rails 5

* System dependencies
docker

* Configuration

Docker must be installed. See: [how to install docker](https://docs.docker.com/engine/installation/)

* Building

To build the docker images, run:
```
$ docker-compose build
```

* Running

To run the rails web container and the mongoDB database container, run:
```
$ docker-compose up
```

* Database

To setup or create the database:
```
$ docker-compose run web rake db:setup
```

To run migrations:
```
$ docker-compose run web rake db:migrate
```

To seed the database with initial values:
```
$ docker-compose run web rake db:seed
``` 

* How to run the test suite
Run rails tests via `$ rake`.

* Deployment instructions

TODO
