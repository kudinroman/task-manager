class CategoriesController < ApplicationController
  def index
    @categories = Category.where(parent_id: nil)
  end

  def show
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update('subcategory', partial: 'categories/subcategory', locals: { category: @category }) }
    end
  end

  def new
    @category = Category.new(parent_id: params[:category_id])
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update('category-header', partial: 'categories/form', locals: { category: @category }) }
    end
  end

  def edit
    @category = Category.find(params[:id])
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update("category-update-#{params[:id]}", partial: 'categories/form', locals: { category: @category }) }
    end
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      respond_to do |format|
        format.html { redirect_to @category.parent_id ? Category.find(@category.parent_id) : categories_path, notice: 'Category was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend('categories_list', partial: 'categories/category', locals: { category: @category }),
            turbo_stream.update('category-header', partial: 'categories/header')
          ]
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.update('category-header', partial: 'categories/form', locals: { category: @category }) }
      end
    end
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      respond_to do |format|
        format.html { redirect_to @category.parent_id ? Category.find(@category.parent_id) : categories_path, notice: 'Category was successfully updated.' }
        format.turbo_stream { render turbo_stream: turbo_stream.update("category-update-#{@category.id}", partial: 'categories/category', locals: { category: @category }) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.update("category-update-#{@category.id}", partial: 'categories/form', locals: { category: @category }) }
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy

    respond_to do |format|
      format.html { redirect_to categories_path }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("category-update-#{@category.id}") }
    end
  end

  def subcategory
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update('subcategory', partial: 'categories/subcategory', locals: { category: @category }) }
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end
end
