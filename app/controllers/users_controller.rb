# encoding: utf-8
class UsersController < ApplicationController
  before_filter :require_sign_in, :require_exist, :require_friend, :only=>[:show, :new_category]
  def show
    @categories = @user.categories.order("id desc").paginate(:page => params[:page], :per_page => 10) if @user
  end
  
  def new_category
    @user ||= User.find_by_nick_name(params[:user_id])
    @category = @user.categories.new
    3.times{
      @category.patterns.build
      @category.responses.build
    }
    render "categories/new"
  end
  
  
  private
  def require_exist
    nick_name = params[:id] || params[:user_id]
    unless @user ||= User.find_by_nick_name(nick_name)
      flash[:error] = "查無此人"
      redirect_to request.referer || root_url
    end
  end
  
  def require_friend
    nick_name = params[:id] || params[:user_id]
    @user ||= User.find_by_nick_name(nick_name)
    if @user && current_user
      unless current_user.id==@user.id || current_user.is_friend_of(@user.plurk_id)
        flash[:error] = "權限不足，他不是你朋友！"
        redirect_to request.referer || root_url
      end
    end
  end
end