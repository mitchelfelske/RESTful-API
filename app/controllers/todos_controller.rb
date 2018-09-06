class TodosController < ApplicationController

  # GET /todos
  def index
    @todos = Todo.all
    json_response(@todos)
  end
end
