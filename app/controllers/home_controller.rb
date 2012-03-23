# encoding: utf-8
class HomeController < ApplicationController
  def index
    @recent_created = Category.order('created_at desc').first(5)
    @recent_updated = Category.where("created_at!=updated_at").order('updated_at desc').first(5)
  end
  
  def search
    if params[:q].present?
      @q = params[:q]
      @categories = []
      @categories |= Category.search_by_pattern(params[:q]) if params[:p]
      @categories |= Category.search_by_title(params[:q]) if params[:t]
    end
    respond_to do |format|
      format.html{flash[:error] = "你沒有輸入任何東西！" unless params[:q].present?}
      format.json{render :json=>@categories}
    end
  end
end
