# encoding: utf-8
class UsersController < ApplicationController
  before_filter :verify_user, :only=>:new_category
  def show
    unless @user = User.find_by_nick_name(params[:id])
      begin
        plurk_id = TJP::get_uid(params[:id])
        user_info = SmallDo.get_public_profile(plurk_id)["user_info"]
        @user = User.new
        @user.user_info = JSON.dump(user_info)
        @user.plurk_id = plurk_id
        @user.nick_name = user_info["nick_name"]
        @user.save!
      rescue => e
        p e
        puts e.backtrace
        flash[:error] = "糟糕！出了點問題"
        redirect_to user_path(current_user)
      end
    end
    @categories = @user.categories.order("id desc")
  end
  
  def new_category
    @user = User.find_by_nick_name(params[:user_id])
    @category = @user.categories.new
    3.times{
      @category.patterns.new
      @category.responses.new
    }
    render "categories/new"
  end
end
