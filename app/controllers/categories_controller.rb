class CategoriesController < ApplicationController
  def index
    @categories = Category.where(parent_id: nil)
    @streams = { list: 'categories_list', header: 'category-header' }
  end

  def show
    @category = Category.find(params[:id])
    @streams = { list: 'subcategories-list', header: 'subcategory-header' }
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update('subcategory', partial: 'categories/subcategory', locals: { category: @category }) }
    end
  end

  def new
    @category = Category.new(parent_id: params[:category_id], depth: (Category.find_by(params[:category_id])&.depth&.+ 1) || 0)
    @frame = params[:frame]
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.update(@frame, partial: 'categories/form', locals: { category: @category }) }
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
    @streams = @category.parent_id.present? ? { list: 'subcategories-list', header: 'subcategory-header' } : { list: 'categories-list', header: 'category-header' }
    if @category.save
      respond_to do |format|
        format.html { redirect_to @category.parent_id ? Category.find(@category.parent_id) : categories_path, notice: 'Category was successfully created.' }
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.prepend(@streams[:list], partial: 'categories/category', locals: { category: @category }),
            turbo_stream.update(@streams[:header], partial: 'categories/header', locals: { category: @category.parent_id.present? ? @category.parent : nil })
          ]
        end
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.update(@streams[:header], partial: 'categories/form', locals: { category: @category }) }
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

  private

  def category_params
    params.require(:category).permit(:name, :parent_id, :turbo_frame)
  end
end
