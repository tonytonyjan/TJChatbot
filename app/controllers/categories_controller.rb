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
    # If it's a personal category, user should signed in
    if params[:category][:user_id] && !current_user
      redirect_to sign_in_path
      return
    end
    
    user = User.find(params[:category][:user_id])
    @category = Category.new(params[:category])
    
    if @category.save
      flash[:success] = "提交成功！"
      redirect_to params[:category][:user_id] ? user_path(user.nick_name) : categories_path
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
    # If it's a personal category, user should signed in
    if params[:category][:user_id] && !current_user
      redirect_to sign_in_path
      return
    end
    
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:success] = "提交成功！"
      redirect_to @category.user ? user_path(@category.user.nick_name) : categories_path 
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
