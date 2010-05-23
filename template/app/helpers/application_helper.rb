module ApplicationHelper

  def layout_class
    controller.layout_type.to_s.dasherize
  end

  def layout_partial
    "layouts/partials/#{controller.layout_type}"
  end
  
end
