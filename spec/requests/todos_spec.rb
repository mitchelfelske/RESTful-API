require 'rails_helper'

RSpec.describe 'Todos API', type: :request do
  #init test data
  let!(:todos) { create_list(:todo, 10) }
  #let(:todo_id) { todos.first.id }

  #Test suit to list all todos
  describe 'GET /todos' do
    # make HTTP get request before each example
    before { get '/todos' }

    it 'returns Ok: Request succeeded' do
      expect(response).to have_http_status(200)
    end

    it 'returns todos' do
      # 'json' is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end
end