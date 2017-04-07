# README

onto-mongo is an ontology mapping/querying application for mongoDB that parses SPARQL queries and uses a mapping to access a mongoDB database, using Ruby on Rails and ActiveModel.

## Ruby version

- ruby 2.3.0
- rails 5

## System dependencies

- Docker

## Configuration

Docker must be installed. See: [how to install docker](https://docs.docker.com/engine/installation/)

## Building

To build the docker images, run:
```
$ docker-compose build
```

## Running

To run the rails web container and the mongoDB database container, run:
```
$ docker-compose up
```

## Database

### Setup or Create the database:

Run:
```
$ docker-compose run web rake db:setup
```

### Migrations

There is no need to run migrations on MongoDB.

### Seeding

To seed the database with initial values:
```
$ docker-compose run web rake db:seed
```

### Indexes
To create mongoDB indices, run:

```
$ rake db:mongoid:create_indexes
```

## Testing

Run rails tests suite via `$ rake`.

## Deployment

TODO
