# encoding: utf-8
class HomeController < ApplicationController
  def index
    @recent_created = Category.order('created_at desc').first(5)
    @recent_updated = Category.order('updated_at desc').first(5)
  end
  
  def search
    @categories = Category.search(params[:q])
    render "categories/index"
  end
end
