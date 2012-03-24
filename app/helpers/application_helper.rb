module ApplicationHelper
  def nav_li name, url, link_option={}
    style = "active" if request.path == URI(url).path
    content_tag :li, link_to(name, url, link_option), :class=>style
  end
  
  def alert_div type
    a = content_tag :a, "x", :class=>"close", "data-dismiss"=>"alert"
    content_tag :div, a+flash[type], :class=>"alert alert-#{type}"
  end
  
  def alert_divs
    ret = "".html_safe
    flash.each do |type, message|
      ret += alert_div(type)
    end
    ret
  end
  
end
