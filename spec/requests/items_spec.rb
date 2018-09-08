require 'rails_helper'

RSpec.describe 'Items API', type: :request do
  # Init testing data
  let!(:todo) { create(:todo) }
  let!(:items) { create_list(:item, 20, todo_id: todo.id) }
  let(:todo_id) { todo.id }
  let(:id) { items.first.id }

  # Test suit for getting a todo items list
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

  # Test suit for getting a todo item
  describe  'GET /todos/:todo_id/items/:id' do
    before { get "/todos/#{todo_id}/items/#{id}" }

    context 'when todo item exists' do
      it 'returns request succeeded status code' do
        expect(response).to have_http_status(200)
      end

      it 'returns the item' do
        expect(json['id']).to eq(id)
      end
    end

    context 'when todo item does not exist' do
      let(:id) { 0 }

      it 'returns not found status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suit for creating an item
  describe 'POST /todos/:todo_id/items' do
    let(:valid_attributes) { { name: "Todo Item 1", done: true } }

    context 'when request attributes are valid' do
      before { post "/todos/#{todo_id}/items", params: valid_attributes}

      it 'returns created status code' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when an invalid request' do
      context 'because all params are missing' do
        before { post "/todos/#{todo_id}/items", params: { } }

        it 'returns unprocessable entity status code' do
          expect(response).to have_http_status(422)
        end

        it 'returns a validation failure message' do
          expect(response.body).to match(/Validation failed: Name can't be blank/)
        end
      end
    end
  end

  # Test suit for updating a post item
  describe 'PUT /todos/:todo_id/items/:id' do
    let(:valid_attributes) { { name: 'Visit Narnia' } }

    before { put "/todos/#{todo_id}/items/#{id}", params: valid_attributes }

    context 'when todo item exists' do
      it 'returns no content status code' do
        expect(response).to have_http_status(204)
      end

      it 'updates the item' do
        updated_item = Item.find(id)
        expect(updated_item.name).to match(/Visit Narnia/)
      end
    end

    context 'when the item does not exist' do
      let(:id) { 0 }

      it 'returns not found status code' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  # Test suite for deleting a todo item
  describe 'DELETE /todos/:todo_id/items/:id' do
    before { delete "/todos/#{todo_id}/items/#{id}" }

    it 'returns no content status code' do
      expect(response).to have_http_status(204)
    end
  end
end
