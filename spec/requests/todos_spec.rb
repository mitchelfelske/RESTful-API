require 'rails_helper'

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
  describe 'GET /todos/:id' do
    before { get "/todos/#{todo_id}" }

    context 'when the record exists' do
      it 'returns request succeeded status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the todo' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(todo_id)
      end
    end

    context 'when the record does not exist' do
      # Defines a non existing todo
      let(:todo_id) { 100 }

      it 'returns resource not found status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  # Test suite for creating a todo
  describe 'POST /todos' do

    let(:valid_attributes) { { title: 'Learn Rails API', created_by: 'User_1' } }

    context 'when the request is valid' do
      before { post '/todos', params: valid_attributes }

      it 'returns created status code' do
        expect(response).to have_http_status(201)
      end

      it 'creates a todo' do
        expect(json['id']).to eq(11)
        expect(json['title']).to eq('Learn Rails API')
        expect(json['created_by']).to eq('User_1')
      end
    end

    context 'when the request is invalid' do
      context 'because all params are missing' do
        before { post '/todos' }

        it 'returns unprocessable entity status code' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed: Title can't be blank, Created by can't be blank/)
        end
      end

      context 'because title is missing' do
        before { post '/todos', params: { created_by: 'User_1' } }

        it 'returns unprocessable entity status code' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed: Title can't be blank/)
        end
      end

      context 'because created by is missing' do
        before { post '/todos', params: { title: 'Learn Rails API' } }

        it 'returns unprocessable entity status code' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed: Created by can't be blank/)
        end
      end
    end
  end
end
