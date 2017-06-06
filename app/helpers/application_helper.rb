module ApplicationHelper
  def navbar_activate(element)
    case element
    when :dashboard
      ["static_pages"].include?(params["controller"]) ? "active" : ""
    when :network
      ["sections","subnets","addresses"].include?(params["controller"]) ? "active" : ""
    else
      ""
    end
  end
end
