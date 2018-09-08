class ItemsController < ApplicationController

  # GET /todos/:todo_id/items
  def index
    @todo = Todo.find(params[:todo_id])
    json_response(@todo.items)
  end
end
