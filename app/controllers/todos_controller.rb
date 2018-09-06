class TodosController < ApplicationController
  before_action :set_todo, only: [:show]

  # GET /todos
  def index
    @todos = Todo.all
    json_response(@todos)
  end

  #GET /todos/:id
  def show
    json_response(@todo)
  end
end

private
def set_todo
  @todo = Todo.find(params[:id])
end
