# encoding: utf-8
class HomeController < ApplicationController
  def index
    @recent_created = Category.order('created_at desc').first(5)
    @recent_updated = Category.order('updated_at desc').first(5)
  end
  
  def search
    if params[:q].present?
      @categories = []
      @categories |= Category.search_by_pattern(params[:q]) if params[:p]
      @categories |= Category.search_by_title(params[:q]) if params[:t]
    elsif params[:q]
      flash[:error] = "你沒有輸入任何東西！"
    end
  end
end
