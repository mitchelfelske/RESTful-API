require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  #init test data
  let!(:todos) { create_list(:todo, 10) }
  let(:todo_id) { todos.first.id }

  # Test suite for listing all todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos' }

    it 'returns ok: request succeeded code' do
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
      it 'returns ok: request succeeded code' do
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

      it 'returns resource not found code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end

  end
end