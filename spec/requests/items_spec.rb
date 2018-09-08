require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  # Init testing data
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }

  # Test suit for getting todo items
  describe 'GET /todos/:todo_id/items' do
    before { get "/todos/#{todo_id}/items" }

    context 'when todo exists' do
      it 'returns request succeeded status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns all todo items' do
        expect(json).not_to be_empty
        expect(json.size).to eq(20)
      end
    end

    context 'when todo does not exist' do
      let(:todo_id) { 0 }

      it 'returns resource not found status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo with 'id'=0/)
      end
    end
  end
end
