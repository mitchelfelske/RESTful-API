# Rails RESTful API

Portfolio showcasing the creation of a Rails RESTful API with:

* Authentication with JWT
* Rspec testing
* API docs (Swagger)

## Run the App

Run server

    rails s

Access app routes documentation

    http://localhost:3000/api-docs

Creates an user account: /signup

Log in to the app (generates a valid token): /auth/login

Authorize routes with generated token

Play around in the restricted area

## Tests

Run rspec tests

    bundle exec rspec --format documentation

## Commands

Generate Swagger Docs

    rake rswag:specs:swaggerize

Access the API

    http://localhost:3000


    
