require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do
  
  
  # todos owner
  let(:user) { create(:user) }

  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # authorize request
  let('Authorization') { token_generator(user.id)}

  path '/todos' do
    get 'Retrieves all todos' do
      tags 'Todo'
      produces 'application/json'
      security [Bearer: {}]      

      response '200', 'Todos list retrieved successfully' do
        schema type: :array,
               properties: {
                   title: { type: :string }
               },
               required: [ 'title', 'created_by' ]

        run_test! do
          expect(json).not_to be_empty
          expect(json.size).to eq(10)
        end
      end
    end
  end
  
  # Test suite for getting a todo
  path '/todos/{id}' do
    get 'Retrieves a Todo' do
      tags 'Todo'
      produces 'application/json'
      security [Bearer: {}]
      parameter name: :id, :in => :path, :type => :string

      response '200', 'Todo retrieved successfully ' do
        schema type: :object,
               properties: {
                   title: { type: :string },
                   created_by: { type: :string }
               },
               required: [ 'title']

        let(:id) { 1 }
        run_test! do
          expect(json).not_to be_empty
          expect(json['id']).to eq(todo_id)
        end
      end

      response '404', 'Todo not found' do
        let(:id) { 'invalid' }
        run_test! do |response|
          expect(response.body).to match(/Couldn't find Todo/)
        end
      end
    end
  end

  # Test suite for creating a todo
  path '/todos' do

    post 'Creates a Todo' do
      tags 'Todo'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :todo, in: :body, schema: {
          type: :object,
          properties: {
              title: { type: :string },
              created_by: { type: :string }
          }, required: [ 'title', 'created_by' ]
      }

      response '201', 'Todo created successfully' do
        let(:todo) { { title: 'Learn API Docs with Swagger', created_by: 'User 1' } }

        run_test! do
          expect(json['id']).to eq(11)
          expect(json['title']).to eq('Learn API Docs with Swagger')
          expect(json['created_by']).to eq('User 1')
        end
      end

      context 'when Title is missing' do
        response '422', 'Unprocessable Entity' do
          let(:todo) { { created_by: 'User 1'} }

          run_test! do |response|
            expect(response.body).to match(/Validation failed: Title can't be blank/)
          end
        end
      end

      context 'when Created By is missing' do
        response '422', 'Unprocessable Entity' do
          let(:todo) { { title: 'Learn API Docs with Swagger'} }

          run_test! do |response|
            expect(response.body).to match(/Validation failed: Created by can't be blank/)
          end
        end
      end

      context 'when Title and Created By are missing' do
        response '422', 'Unprocessable Entity' do
          let(:todo) { }

          run_test! do |response|
            expect(response.body).to match(/Validation failed: Title can't be blank, Created by can't be blank/)
          end
        end
      end
    end
  end

  # Test suit for updating a todo
  path '/todos/{id}' do

    put 'Updates a Todo' do
      tags 'Todo'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :id, :in => :path, :type => :string
      parameter name: :todo, in: :body, schema: {
          type: :object,
          properties: {
              title: { type: :string },
              created_by: { type: :string }
          }
      }
      
      response '204', 'Todo updated successfully' do
        let(:todo) { { title: 'Learning Node.js RESTful APIs' } }
        let(:id) { todo_id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end
      
      context 'when the record does not exist' do
        response '404', 'Todo not found' do
          let(:todo) { { title: 'Learning Node.js RESTful APIs' } }
          let(:id) { 'invalid' }

          run_test! do |response|
            expect(response.body).to match(/Couldn't find Todo/)
          end
        end
      end
    end
  end

  # Test suit for deleting a todo
  path '/todos/{id}' do

    delete 'Deletes a Todo' do
      tags 'Todo'
      consumes 'application/json'
      security [Bearer: {}]
      parameter name: :id, :in => :path, :type => :string

      response '204', 'Todo deleted successfully' do
        let(:id) { todo_id }

        run_test! do |response|
          expect(response.body).to be_empty
        end
      end

      context 'when the record does not exist' do
        response '404', 'Todo not found' do
          let(:id) { 'invalid' }

          run_test! do |response|
            expect(response.body).to match(/Couldn't find Todo/)
          end
        end
      end
    end
  end
end
