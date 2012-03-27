# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :signed_in?, :current_user
  
  
  def plurk_consumer
    @consumer ||= OAuth::Consumer.new("tPncMPx4HhTx", "sck0hH0nAD01E4zwZguJzlqhjtEYvpc0", {
        :site               => 'http://www.plurk.com',
        :scheme             => :header,
        :http_method        => :post,
        :request_token_path => '/OAuth/request_token',
        :access_token_path  => '/OAuth/access_token',
        :authorize_path     => '/OAuth/authorize'
    })
  end
  
  def require_sign_in
    unless current_user && current_user.signed_up?
      session[:sign_in_request_url] = request.url
      redirect_to sign_in_path
    end
  end
  
  def current_user
    @current_user ||= User.find_by_plurk_id(session[:plurk_id]) if session[:plurk_id]
  end
  
  def signed_in?
    current_user
  end
end
