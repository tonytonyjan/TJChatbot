# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :verify_user
  
  def sign_in
    unless signed_in?
      @request_token = plurk_consumer.get_request_token :oauth_callback=>sign_in_callback_url
      session[:request_token] = @request_token
      @authorize_url = @request_token.authorize_url
      redirect_to @authorize_url
    else
      flash[:info]="你已是登入狀態"
      redirect_to root_url
    end
  end

  def sign_out
    session[:plurk_id] = nil
    flash[:success] = "已登出"
    redirect_to root_url
  end

  def sign_in_callback
    # Retrieve data from plurk
    @request_token = session[:request_token]
    access_token = @request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    own_profile = JSON.parse(access_token.post('/APP/Profile/getOwnProfile').body)
    if own_profile["error_text"]
      flash["error"] = "噗浪出了點問題，暫時無法登入"
      redirect_to root_url
      return
    end
    user_info = own_profile["user_info"]
    
    # New an user if the user is not found in database
    unless user = User.find_by_plurk_id(user_info["id"])
      user = User.new
      user.plurk_id = user_info["id"]
    end
    user.nick_name = user_info["nick_name"] unless user.nick_name 
    user.oauth_token = JSON.dump(access_token.token)
    user.oauth_token_secret = JSON.dump(access_token.secret)
    user.user_info = JSON.dump(user_info)

    if user.save
      session[:plurk_id] = user.plurk_id
    else
      flash[:error] ="登入失敗，無法建立資料，請洽管理員"
    end
    
    redirect_to root_url
  rescue => e
    p e
    puts e.backtrace
    redirect_to sign_in_url
  end
end
