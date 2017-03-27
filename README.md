
**Onebnb API**
===================

![ruby](https://img.shields.io/badge/Ruby-2.3.3-red.svg)
![rails](https://img.shields.io/badge/Rails-5.0.1-red.svg)
![rails](https://img.shields.io/docker/automated/jrottenberg/ffmpeg.svg)

#About the project

This is a OneBitCode course project whose goal is to develop a replica of the Airbnb hosting reservations system. In this repository will be produced the system API using Ruby on Rails 5 API, PostgreSQL, Elastic Search, Redis, Docker for project containerization.


# Require
```
  * Docker
  * Docker Compose
```
# Stack
```
  * Application  
  * Postgres
  * Elastic Search
  * Redis
```
# Getting Started

## 1. Clone this repository

## 2. Run within the project:
```
   $ mkdir data data/application && touch data/application/.env
```   

## 3. Add data/application/.env
```
  cp data/application/.env.dist data/application/.env
```

## 4. Start docker-compose
```
   $ docker-compose up --build      
```

# Run
```
$ docker-compose run website rails db:create db:migrate
```
with Elastic Search runing: `$ docker-compose run website rails db:seed`

# Test App
```
$ docker-compose run website rspec
```
