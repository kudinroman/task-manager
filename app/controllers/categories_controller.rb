class CategoriesController < ApplicationController
  def index
    @categories = Category.where(parent_id: nil)
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new(parent_id: params[:category_id])
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category.parent_id ? Category.find(@category.parent_id) : categories_path
    else
      render :new
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to @category.parent_id ? Category.find(@category.parent_id) : categories_path
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
