# encoding: utf-8
class HomeController < ApplicationController
  def index
    @recent_created = Category.where('user_id IS NULL').order('created_at desc').first(5)
    @recent_updated = Category.where("created_at!=updated_at AND user_id IS NULL").order('updated_at desc').first(5)
  end
  
  def search
    if params[:q].present?
      @q = params[:q]
      @categories = []
      @categories |= Category.search_by_pattern(params[:q]) if params[:p]
      @categories |= Category.search_by_title(params[:q]) if params[:t]
    end
    respond_to do |format|
      format.html{flash[:error] = "你沒有輸入任何東西！" if params[:q] && params[:q].blank?}
      format.json{render :json=>@categories}
    end
  end
  
  # For AJAX
  
  def status
    render :json=>SmallDo.get_own_profile
  end
  
  def get_friends
    if current_user
      response = current_user.tjp.get_completion
      if response["error_text"]
        redirect_to sign_in_path
      else
        render :json=>response
      end
    else
      redirect_to sign_in_path
    end
  end
end
