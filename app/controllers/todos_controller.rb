class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy]

  def index
    @todos = Todo.all
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      render turbo_stream: [
        turbo_stream.append("todos", partial: "todo", locals: { todo: @todo }),
        turbo_stream.remove("form"),
        turbo_stream.prepend("main", partial: "form", locals: { todo: Todo.new })
      ]
    else
      render :new, status: :unprocessable_entity
    end
  end
  

  def edit
  end

  def update
    if @todo.update(todo_params)
      redirect_to todos_path, notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @todo.destroy
    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Task was successfully destroyed." }
      format.turbo_stream
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:task)
  end
end