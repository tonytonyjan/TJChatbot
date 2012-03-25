class User < ActiveRecord::Base
  attr_protected :plurk_id, :user_info, :nick_name, :access_token
  attr_reader :info
  after_initialize :init
  
  validates :plurk_id, :user_info, :nick_name, :access_token, :presence=>true
  
  def to_param
    plurk_id
  end
  
  # :size: should be one of (small|medium|big)
  def avatar size="small"
    size = "small" if ! size =~ /^(?:small|medium|big)$/
    
    has_profile_image, avatar = info["has_profile_image"], info["avatar"]
    if has_profile_image && avatar
      "http://avatars.plurk.com/#{plurk_id}-#{size}#{avatar}." + (size=="big"?"jpg":"gif")
    elsif has_profile_image
      "http://avatars.plurk.com/#{plurk_id}-#{size}." + (size=="big"?"jpg":"gif")
    else
      "http://www.plurk.com/static/default_#{size}.gif"
    end
  end
  
  private
  def init
    @info = JSON.parse(user_info) if user_info
  end
end