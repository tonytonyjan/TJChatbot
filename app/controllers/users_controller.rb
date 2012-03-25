class UsersController < ApplicationController
  def show
    unless @user = User.find_by_nick_name(params[:id])
      
    end
  end
end
