module ApplicationHelper
  def navbar_activate(element)
    case element
    when :dashboard
      ["static_pages"].include?(params["controller"]) ? "active" : ""
    when :report
      ["reports"].include?(params["controller"]) ? "active" : ""
    when :network
      ["sections","subnets","addresses"].include?(params["controller"]) ? "active" : ""
    when :hosting_virtual
      ["data_centers", "clusters", "hosts"].include?(params["controller"]) ? "active" : ""
    when :almacenamiento
      ["storage_boxes", "aggregates", "volumes"].include?(params["controller"]) ? "active" : ""
    else
      ""
    end
  end

  def two_decimal_amount(amount, separator=',')
      number_with_precision(amount, :precision => 2, :separator => separator)
  end

  def kb_to_human(amount)
    units = %w(KB MB GB TB PB EB).cycle
    unit = units.next

    while(amount / 1024.0 >= 1)
      amount /= 1024.0
      unit = units.next
    end

    "#{two_decimal_amount amount} #{unit}"
  end
end
