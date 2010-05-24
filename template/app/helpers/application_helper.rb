module ApplicationHelper

  def layout_css_class
    controller.layout_view.to_s.dasherize
  end

  def layout_partial
    "layouts/partials/#{controller.layout_view}"
  end

  def layout_css_path
    "compiled/#{controller.layout_type}_screen.css"
  end
  
end
