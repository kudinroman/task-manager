class TasksController < ApplicationController
  before_action :set_category

  def new
    @task = @category.tasks.new
  end

  def edit
    @task = @category.tasks.find(params[:id])
  end

  def create
    @task = @category.tasks.new(task_params)
    if @task.save
      redirect_to @category
    else
      render :new
    end
  end

  def update
    @task = @category.tasks.find(params[:id])
    if @task.update(task_params)
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    @task = @category.tasks.find(params[:id])
    @task.destroy
    redirect_to @category
  end

  private

  def set_category
    @category = Category.find(params[:category_id])
  end

  def task_params
    params.require(:task).permit(:name, :description, :status)
  end
end
