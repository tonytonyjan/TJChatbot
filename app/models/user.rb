class User < ActiveRecord::Base
  attr_protected :plurk_id, :user_info, :nick_name, :access_token
  validates :plurk_id, :user_info, :nick_name, :presence=>true
  has_many :categories
  has_many :patterns, :foreign_key=>:last_edit_user_id
  has_many :responses, :foreign_key=>:last_edit_user_id
  
  def to_param
    nick_name
  end
  
  def info
    @info ||= JSON.parse(user_info) if user_info
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
end
