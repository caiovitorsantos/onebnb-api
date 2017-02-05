# API OneBnb

This is a OneBitCode course project whose goal is to develop a replica of the Airbnb hosting reservations system. In this repository will be produced the system API using Ruby on Rails 5 API, postgreSQL, Redis, Docker for project containerization.

To run the project you must have Docker and docker compose installed on your computer

* Clone this repository: `git clone git@github.com:caiovitorsantos/onebnb-api.git` or `git clone https://github.com/caiovitorsantos/onebnb-api.git`

* On bash inside project directory run this command: `docker-compose up --build` and wait...

* Create the database and your tables: `docker-compose run website rake db:create` and then `docker-compose run website rake db:migrate`. You can also seed your DB with example data with: `docker-compose run website rake db:seed`
