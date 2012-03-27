# encoding: utf-8
class CategoriesController < ApplicationController
  before_filter :require_sign_in_if_is_private, :require_friend, :only=>[:create, :edit, :update]
  
  def index
    @categories = Category.where('user_id IS NULL').order("id desc").paginate(:page => params[:page], :per_page => 10)
  end
  
  def new
    @category = Category.new
    
    3.times{
      @category.patterns.build
      @category.responses.build
    }
  end
  
  def create    
    @category ||= Category.new(params[:category])

    # if user signed in, then record his name
    if current_user
      @category.patterns.each{|p| p.last_edit_user_id = current_user.id}
      @category.responses.each{|r| r.last_edit_user_id = current_user.id}
    end
    
    if @category.save
      flash[:success] = "提交成功！"
      redirect_to @category.private? ? user_path(@category.user.nick_name) : categories_path
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
    @category ||= Category.find(params[:id])
  end
  
  def update
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    
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
  
  private
  def require_sign_in_if_is_private
    if params[:id]
      @category ||= Category.find(params[:id])
    elsif params[:category]
      @category ||= Category.new(params[:category])
    end
    
    if @category && @category.private?
      require_sign_in
    end
  end
  
  def require_friend
    if params[:id]
      @category ||= Category.find(params[:id])
    elsif params[:category]
      @category ||= Category.new(params[:category])
    end
    
    unless current_user.id==@category.user.id || current_user.is_friend_of(@category.user.plurk_id)
      flash[:error] = "權限不足，他不是你朋友！"
      redirect_to root_url
    end
    
  end
end
