class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @todos = current_user.todos
    json_response(@todos)
  end

  #GET /todos/:id
  def show
    json_response(@todo)
  end

  # POST /todos
  def create
    @todo = current_user.todos.create!(todo_params)
    json_response(@todo, :created)
  end

  # PUT /todos/:id
  def update
    @todo.update(todo_params)
    head :no_content
  end

  # DELETE /todos/:id
  def destroy
    @todo.destroy
    head :no_content
  end
end

private

def todo_params
  params.permit(:title, :created_by)
end

def set_todo
  @todo = Todo.find(params[:id])
end
