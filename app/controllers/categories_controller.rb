# encoding: utf-8
class CategoriesController < ApplicationController
  
  def index
    @categories = Category.order("id desc")
  end
  
  def new
    @category = Category.new
    3.times{
      @category.patterns.new
      @category.responses.new
    }
  end
  
  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:success] = "提交成功！"
      redirect_to edit_category_path(@category)
    else
      flash.now[:error] = "提交失敗！"
      need_patterns = 3 - @category.patterns.size
      need_responses = 3 - @category.responses.size
      need_patterns.times{@category.patterns.new}
      need_responses.times{@category.responses.new}
      render "new"
    end
  end
  
  def edit
    @category = Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:success] = "提交成功！"
      redirect_to edit_category_path(@category)
    else
      flash.now[:error] = "提交失敗！"
      need_patterns = 3 - @category.patterns.size
      need_responses = 3 - @category.responses.size
      need_patterns.times{@category.patterns.new}
      need_responses.times{@category.responses.new}
      render "edit"
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end
end
