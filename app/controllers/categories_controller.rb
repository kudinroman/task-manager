class CategoriesController < ApplicationController
  def index
    @categories = Category.where(parent_id: nil).ordered
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    depth = params[:category_id].present? ? Category.find(params[:category_id]).depth + 1 : 0
    @category = Category.new(parent_id: params[:category_id], depth: depth)
  end

  def edit
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path, notice: 'Category was successfully.' }
        format.turbo_stream
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      respond_to do |format|
        format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
        format.turbo_stream
      end
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_path, notice: 'Category was successfully destroyed.' }
      format.turbo_stream
    end
  end

  def subcategory
    @category = Category.find(params[:id])
    stream_name = "subcategory_#{@category.depth}"
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update(stream_name, partial: 'categories/subcategory', locals: { category: @category }) }
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :turbo_frame, :depth)
  end
end
