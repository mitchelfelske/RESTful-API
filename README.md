# Rails RESTful API

Portfolio showcasing the creation of a Rails RESTful API with:

* Authentication with JWT
* Pagination
* Rspec requests testing
* Swagger docs for the created routes

## Commands

Generate Swagger Docs

    rake rswag:specs:swaggerize

Run rspec tests

    bundle exec rspec --format documentation

Run server

    rails s

Access the API

    http://localhost:3000

Access Swagger docs

    http://localhost:3000/api-docs
    