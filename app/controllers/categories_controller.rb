# encoding: utf-8
class CategoriesController < ApplicationController
  def index
    @categories = Category.where('user_id IS NULL').order("id desc")
  end
  
  def new
    @category = Category.new
    
    # If it's a personal category, user should signed in
    if @category.user && !current_user
      verify_user
      return
    end
    
    3.times{
      @category.patterns.build
      @category.responses.build
    }
  end
  
  def create
    # If it's a personal category, user should signed in
    if params[:category][:user_id] && !current_user
      redirect_to sign_in_path
      return
    end
    
    user = User.find(params[:category][:user_id]) if params[:category][:user_id]
    @category = Category.new(params[:category])
    
    # If it's a personal category, user should signed in
    if @category.user && !current_user
      verify_user
      return
    end
    
    # if user signed in, then record his name
    if current_user
      @category.patterns.each{|p| p.last_edit_user_id = current_user.id}
      @category.responses.each{|r| r.last_edit_user_id = current_user.id}
    end
    
    if @category.save
      flash[:success] = "提交成功！"
      redirect_to user ? user_path(user.nick_name) : categories_path
    else
      flash.now[:error] = "提交失敗！"
      need_patterns = 3 - @category.patterns.size
      need_responses = 3 - @category.responses.size
      need_patterns.times{@category.patterns.build}
      need_responses.times{@category.responses.build}
      render "new"
    end
  end
  
  def edit
    @category = Category.find(params[:id])
    
    # If it's a personal category, user should signed in
    if @category.user && !current_user
      verify_user
      return
    end
  end
  
  def update
    
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    
    if @category.user && !current_user
      verify_user
      return
    end
    
    # if user signed in, then record his name
    if current_user
      @category.patterns.each{|p| p.last_edit_user_id = current_user.id if p.changed?}
      @category.responses.each{|r| r.last_edit_user_id = current_user.id if r.changed?}
    end
    
    if @category.save
      flash[:success] = "提交成功！"
      redirect_to @category.user ? user_path(@category.user.nick_name) : categories_path 
    else
      flash.now[:error] = "提交失敗！"
      need_patterns = 3 - @category.patterns.size
      need_responses = 3 - @category.responses.size
      need_patterns.times{@category.patterns.build}
      need_responses.times{@category.responses.build}
      render "edit"
    end
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path
  end
  
end
