class User < ActiveRecord::Base
  attr_protected :plurk_id, :user_info, :nick_name, :access_token
  validates :plurk_id, :user_info, :nick_name, :presence=>true
  has_many :categories
  has_many :patterns, :foreign_key=>:last_edit_user_id
  has_many :responses, :foreign_key=>:last_edit_user_id
  
  def self.find_by_plurk_id plurk_id
    ret = super plurk_id
    return ret if ret
    begin
      user_info = SmallDo.get_public_profile(plurk_id)["user_info"]
      @user = User.new
      @user.user_info = JSON.dump(user_info)
      @user.plurk_id = plurk_id
      @user.nick_name = user_info["nick_name"]
      @user.save!
      return @user
    rescue => e
      return false
    end
  end
  
  def self.find_by_nick_name nick_name
    ret = super nick_name
    return ret if ret
    begin
      plurk_id = TJP::get_uid(nick_name)
      user_info = SmallDo.get_public_profile(plurk_id)["user_info"]
      @user = User.new
      @user.user_info = JSON.dump(user_info)
      @user.plurk_id = plurk_id
      @user.nick_name = user_info["nick_name"]
      @user.save!
      return @user
    rescue => e
      return false
    end
  end
  
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
  
  def is_friend_of plurk_id
    tjp.get_public_profile(plurk_id)["are_friends"]
  end
  
  def tjp
    @tjp ||= TJP::TJPlurker.new "tPncMPx4HhTx", "sck0hH0nAD01E4zwZguJzlqhjtEYvpc0", oauth_token, oauth_token_secret
  end
  
  def signed_up?
    attributes.each_value{|v| return false unless v}
    return true
  end
end
