class ApplicationController < ActionController::Base
  protect_from_forgery

  TITLE = "Application Title"

  attr_accessor_with_default :layout_type, :content_sidebar_layout
  
end
