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

  # POST /todos
  def create
    @todo = Todo.create!(todo_params)
    json_response(@todo, :created)
  end
end

private
def todo_params
  params.permit(:title, :created_by)
end

def set_todo
  @todo = Todo.find(params[:id])
end
