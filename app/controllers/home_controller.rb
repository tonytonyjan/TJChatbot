# encoding: utf-8
class HomeController < ApplicationController
  def index
    @recent_created = Category.actived.public.order('created_at desc').first(5)
    @recent_updated = Category.actived.public.where("created_at!=updated_at").order('updated_at desc').first(5)
  end
  
  def search
    if params[:q].present?
      @q = params[:q]
      @t = params[:t] # topic
      @p = params[:p] # pattern
      @categories = Category.search(params).paginate(:page => params[:page], :per_page => 10)
    end
    
    respond_to do |format|
      format.html{
        flash[:error] = "你沒有輸入任何東西！" if params[:q] && params[:q].blank?
        render "categories/index"
      }
      format.json{render :json=>@categories}
    end
  end
  
  def trash_can
    @categories = Category.unactived.public.order("updated_at desc").paginate(:page => params[:page], :per_page => 10)
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
