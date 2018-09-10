require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Todos API', type: :request do
  #init test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # Test suite for listing all todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos' }

    it 'returns request succeeded status code' do
      expect(response).to have_http_status(200)
    end

    it 'returns todos' do
      # 'json' is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end

  # Test suite for getting a todo
  path '/todos/{id}' do
    get 'Retrieves a Todo' do
      tags 'Todo'
      produces 'application/json'
      parameter name: :id, :in => :path, :type => :string

      response '200', 'Todo found' do
        schema type: :object,
               properties: {
                   title: { type: :string },
                   created_by: { type: :string }
               },
               required: [ 'title', 'created_by' ]

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
      parameter name: :todo, in: :body, schema: {
          type: :object,
          properties: {
              title: { type: :string },
              created_by: { type: :string }
          }, required: [ 'title', 'created_by' ]
      }

      response '201', 'Todo created' do
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
  describe 'PUT /todos/:id' do
    let(:valid_attributes) { { title: 'Learn Node.js API' } }

    context 'when the record exists' do
      before { put "/todos/#{todo_id}", params: valid_attributes }

      it 'returns no content status code' do
        expect(response).to have_http_status(204)
      end

      it 'updates the record' do
        expect(response.body).to be_empty
      end
    end

    context 'when the record does not exist' do
      # Defines a non existing todo
      let(:todo_id) { 100 }

      before { put "/todos/#{todo_id}", params: valid_attributes }

      it 'returns resource not found status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suit for deleting a todo
  describe 'DELETE /todos/:id' do
    before { delete "/todos/#{todo_id}" }

    it "returns no content status code" do
      expect(response).to have_http_status(204)
    end

  end
end
