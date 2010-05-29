require "base64"

# Helper functions

def binary_file(file_name, base64content, log_action = true)
  log 'binary_file', file_name if log_action
  dir, file = [File.dirname(file_name), File.basename(file_name)]

  inside(dir) do
    File.open(file, "wb") do |f|
      f.write Base64.decode64(base64content)
    end
  end
end

# Remove unused files
run "rm public/index.html"
run "rm app/views/layouts/application.html.erb"

# Add used gems
gem "russian", :version => ">=0.2.5"
gem "haml", :version => ">=3.0.4"
gem "compass", :version => ">= 0.10.1"

gem "rspec", :version => ">=2.0.0.beta.8", :group => :test
gem "rspec-rails", :version => ">=2.0.0.beta.8", :group => :test

# Install rspec
run "rails g rspec:install"

# Additional application files
file ".gitignore", %q{.idea
.bundle
db/*.sqlite3
db/schema.rb
log/*.log
tmp/**/*
public/stylesheets/compiled}



file "app/views/main/index.html.haml", %q{%h1 Home#index
%p
  Find me in app/views/home/index.html.erb
}

file "app/views/layouts/_main_navigation.html.haml", %q{}

file "app/views/layouts/_footer.html.haml", %q{%p
  != "Copyright &copy; 2008 &ndash; #{Date.today.year} #{ApplicationController::TITLE}"}

file "app/views/layouts/_header.html.haml", %q{%h1
  %a{ :href => "/" }= ApplicationController::TITLE
= render :partial => "layouts/user_navigation"
= render :partial => "layouts/main_navigation"}

file "app/views/layouts/_user_navigation.html.haml", %q{.app-user-navigation
  %ul
    %li
      %a(href="ya.ru") Link 1
    %li
      %a(href="ya.ru") Link 2}

file "app/views/layouts/partials/_sidebar_content_layout.html.haml", %q{.app-sidebar
  sidebar
.app-content
  = yield
}

file "app/views/layouts/partials/_sidebar_content_sidebar_layout.html.haml", %q{.app-left-sidebar
  left-sidebar
.app-content
  = yield
.app-right-sidebar
  right-sidebar
}

file "app/views/layouts/partials/_content_sidebar_layout.html.haml", %q{.app-content
  = yield
.app-sidebar
  sidebar}

file "app/views/layouts/partials/_content_layout.html.haml", %q{.app-content
  = yield}

file "app/views/layouts/application.html.haml", %q{!!! XML
!!! Strict
%html{ :xmlns => "http://www.w3.org/1999/xhtml" }
  %head
    %meta{ :"http-equiv" => "Content-Type", :content => "text/html; charset=utf-8" } 
    %title= ApplicationController::TITLE
    = javascript_include_tag :defaults, :cache => "all"
    = stylesheet_link_tag layout_css_path, :media => 'screen, projection'
    = stylesheet_link_tag 'compiled/print.css', :media => 'print'
    /[if lt IE 8]
      = stylesheet_link_tag 'compiled/ie.css', :media => 'screen, projection'
  %body.bp{:class => "#{layout_css_class}"}
    .app-container
      .app-header= render :partial => "layouts/header"
      = render :partial => layout_partial
      .app-footer= render :partial => "layouts/footer"}

file "app/helpers/application_helper.rb", %q{module ApplicationHelper

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
}

file "app/helpers/main_helper.rb", %q{module MainHelper
end
}

file "app/stylesheets/liquid_screen.scss", %q{@import "screen";
@import "layouts/liquid_layout";}

file "app/stylesheets/_screen.scss", %q{// This import applies a global reset to any page that imports this stylesheet.
@import "blueprint/reset";
@import "compass/reset/utilities";

// To configure blueprint, edit the partials/base.sass file.
@import "partials/base";

// Import all the default blueprint modules so that we can access their mixins.
@import "blueprint";

// Combine the partials into a single screen stylesheet.
@import "partials/page";
@import "partials/form";
@import "partials/header";
@import "partials/user_navigation";
@import "partials/footer";
}

file "app/stylesheets/partials/_user_navigation.scss", %q{body .app-user-navigation {
  position: absolute;
  right: 20px;
  top: 0;

  ul {
    @include reset-box-model;
    @include reset-list-style;
    @include clearfix;
    
    li {
      padding: 5px 10px;
      float: left;

      a {
        text-decoration: none;
      }
    }
  }
}}

file "app/stylesheets/partials/_base.scss", %q{// Here is where you can define your constants for your application and to configure the blueprint framework.
// Feel free to delete these if you want keep the defaults:

$blueprint-grid-columns: 24;
$blueprint-container-size: 950px;
$blueprint-grid-margin: 10px;

// Use this to calculate the width based on the total width.
// Or you can set !blueprint_grid_width to a fixed value and unset !blueprint_container_size -- it will be calculated for you.
$blueprint-grid-width: ($blueprint-container-size + $blueprint-grid-margin) / $blueprint-grid-columns - $blueprint-grid-margin;
}

file "app/stylesheets/partials/_footer.scss", %q{body .app-footer {
  background-color: $feedback_border_color;
  border-top: 1px solid $quiet_color; 

  p {
    text-align: right;
    margin: 15px 0;
    padding: 0 10px;
  }
}}

file "app/stylesheets/partials/_header.scss", %q{body .app-header {
  background-color: $feedback_border_color;
  border-bottom: 1px solid $quiet_color;
  padding: 5px 20px; 

  h1 {
    padding: 5px 0;
    margin: 5px 0;

    a {
      text-decoration: none;
    }
  }
}}

file "app/stylesheets/partials/_page.scss", %q{// Import the non-default scaffolding module to help us get started.
@import "blueprint/scaffolding";

// This configuration will only apply the
// blueprint styles to pages with a body class of "bp"
// This makes it easier to have pages without blueprint styles
// when you're using a single/combined stylesheet.

body.bp {
  @include blueprint-typography(true);
  @include blueprint-utilities;
  @include blueprint-debug;
  @include blueprint-interaction; }

// Remove the scaffolding when you're ready to start doing visual design.
// Or leave it in if you're happy with how blueprint looks out-of-the-box
@include blueprint-scaffolding("body.bp");
}

file "app/stylesheets/partials/_form.scss", %q{// Only apply the blueprint form styles to forms with
// a class of "bp". This makes it easier to style
// forms from scratch if you need to.

form.bp {
  @include blueprint-form; }
}

file "app/stylesheets/print.scss", %q{@import "blueprint";

// To generate css equivalent to the blueprint css but with your configuration applied, uncomment:
// +blueprint-print

//Recommended Blueprint configuration with scoping and semantic layout:
body.bp {
  @include blueprint-print(true); }
}

file "app/stylesheets/layouts/_fixed_layout.scss", %q{$layout-type: fixed;
$grid-columns: $blueprint-grid-columns;

@import "layouts";}

file "app/stylesheets/layouts/_liquid_layout.scss", %q{@import "blueprint/liquid";

$layout-type: liquid;
$grid-columns: $blueprint-liquid-grid-columns;
$blueprint_liquid_container_width: 99%;

@import "layouts";}

file "app/stylesheets/layouts/_layouts.scss", %q{$parts: 0;

// Common elements
body {
  .app-container {
    @include container;
    @include showgrid;
    position: relative; }
  .app-header, .app-footer {
    @include column($grid-columns); } }

// Content layout
body.content-layout {
  .app-content {
    @include column($grid-columns, true); } }


// Set number of parts for Content-Sidebar and Sidebar-Content layouts
@if $layout-type == fixed {
  $parts: 3;
} @else {
  $parts: 5;
}

// Content-Sidebar layout
body.content-sidebar-layout {
  .app-sidebar {
    $sidebar-columns: floor($grid-columns / $parts);
    @include column($sidebar-columns); }
  .app-content {
    $content-columns: ceil(($parts - 1) * $grid-columns / $parts);
    @include column($content-columns, true); } }

// Sidebar-Content layout
body.sidebar-content-layout {
  .app-sidebar {
    $sidebar-columns: floor($grid-columns / $parts);
    @include column($sidebar-columns); }
  .app-content {
    $content-columns: ceil(($parts - 1) * $grid-columns / $parts);
    @include column($content-columns, true); } }

// Set number of parts for Sidebar-Content-Sidebar layout
@if $layout-type == fixed {
  $parts: 4;
} @else {
  $parts: 6;
}

// Sidebar-Content-Sidebar layout
body.sidebar-content-sidebar-layout {
  .app-left-sidebar {
    $sidebar-columns: floor($grid-columns / $parts);
    @include column($sidebar-columns); }
  .app-content {
    $content-columns: ceil(($parts - 2) * $grid-columns / $parts);
    @include column($content-columns); }
  .app-right-sidebar {
    $sidebar-columns: floor($grid-columns / $parts);
    @include column($sidebar-columns, true); } }}

file "app/stylesheets/ie.scss", %q{@import "blueprint";

// To generate css equivalent to the blueprint css but with your configuration applied, uncomment:
// +blueprint-ie

//Recommended Blueprint configuration with scoping and semantic layout:
body.bp {
  @include blueprint-ie(true);
  // Note: Blueprint centers text to fix IE6 container centering.
  // This means all your texts will be centered under all version of IE by default.
  // If your container does not have the .container class, don't forget to restore
  // the correct behavior to your main container (but not the body tag!)
  // Example:
  // .my-container
  //   text-align: left
}
}

file "app/stylesheets/fixed_screen.scss", %q{@import "screen";
@import "layouts/fixed_layout";}

file "app/controllers/application_controller.rb", %q{class ApplicationController < ActionController::Base
  protect_from_forgery

  TITLE = "Application Title"

  attr_accessor_with_default :layout_view, :content_sidebar_layout
  attr_accessor_with_default :layout_type, :fixed

end
}

file "app/controllers/main_controller.rb", %q{class MainController < ApplicationController

  def index
#    self.layout_view = :sidebar_content_sidebar_layout
#    self.layout_type = :liquid
  end

end
}



file "config/locales/en.yml", %q{# Sample localization file for English. Add more files in this directory for other locales.
# See http://github.com/svenfuchs/rails-i18n/tree/master/rails%2Flocale for starting points.

en:
  hello: "Hello world"
}


file "config/initializers/compass.rb", %q{require 'compass'
rails_root = (defined?(Rails) ? Rails.root : RAILS_ROOT).to_s
Compass.add_project_configuration(File.join(rails_root, "config", "compass.rb"))
Compass.configure_sass_plugin!
Compass.handle_configuration_change!
}


file "config/compass.rb", %q{# This configuration file works with both the Compass command line tool and within Rails.
# Require any additional compass plugins here.
project_type = :rails
project_path = defined?(Rails) ? Rails.root : RAILS_ROOT
# Set this to the root of your project when deployed:
http_path = "/"
css_dir = "public/stylesheets/compiled"
sass_dir = "app/stylesheets"
environment = Compass::AppIntegration::Rails.env
# To enable relative paths to assets via compass helper functions. Uncomment:
# relative_assets = true
}




file "db/seeds.rb", %q{# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
}



file "lib/tasks/rspec.rake", %q{begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue MissingSourceFile 
  module Rspec
    module Core
      class RakeTask
        def initialize(name)
          task name do
            # if rspec-rails is a configured gem, this will output helpful material and exit ...
            require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")

            # ... otherwise, do this:
            raise <<-MSG

#{"*" * 80}
*  You are trying to run an rspec rake task defined in
*  #{__FILE__},
*  but rspec can not be found in vendor/gems, vendor/plugins or system gems.
#{"*" * 80}
MSG
          end
        end
      end
    end
  end
end

Rake.application.instance_variable_get('@tasks').delete('default')

spec_prereq = Rails.root.join('config', 'database.yml').exist? ? "db:test:prepare" : :noop
task :noop do
end

task :default => :spec
task :stats => "spec:statsetup"

desc "Run all specs in spec directory (excluding plugin specs)"
Rspec::Core::RakeTask.new(:spec => spec_prereq)

namespace :spec do
  [:requests, :models, :controllers, :views, :helpers, :mailers, :lib].each do |sub|
    desc "Run the code examples in spec/#{sub}"
    Rspec::Core::RakeTask.new(sub => spec_prereq) do |t|
      t.pattern = "./spec/#{sub}/**/*_spec.rb"
    end
  end

  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << %w(Model\ specs spec/models) if File.exist?('spec/models')
    ::STATS_DIRECTORIES << %w(View\ specs spec/views) if File.exist?('spec/views')
    ::STATS_DIRECTORIES << %w(Controller\ specs spec/controllers) if File.exist?('spec/controllers')
    ::STATS_DIRECTORIES << %w(Helper\ specs spec/helpers) if File.exist?('spec/helpers')
    ::STATS_DIRECTORIES << %w(Library\ specs spec/lib) if File.exist?('spec/lib')
    ::STATS_DIRECTORIES << %w(Mailer\ specs spec/mailers) if File.exist?('spec/mailers')
    ::STATS_DIRECTORIES << %w(Routing\ specs spec/routing) if File.exist?('spec/routing')
    ::STATS_DIRECTORIES << %w(Request\ specs spec/requests) if File.exist?('spec/requests')
    ::CodeStatistics::TEST_TYPES << "Model specs" if File.exist?('spec/models')
    ::CodeStatistics::TEST_TYPES << "View specs" if File.exist?('spec/views')
    ::CodeStatistics::TEST_TYPES << "Controller specs" if File.exist?('spec/controllers')
    ::CodeStatistics::TEST_TYPES << "Helper specs" if File.exist?('spec/helpers')
    ::CodeStatistics::TEST_TYPES << "Library specs" if File.exist?('spec/lib')
    ::CodeStatistics::TEST_TYPES << "Mailer specs" if File.exist?('spec/mailer')
    ::CodeStatistics::TEST_TYPES << "Routing specs" if File.exist?('spec/routing')
    ::CodeStatistics::TEST_TYPES << "Request specs" if File.exist?('spec/requests')
  end
end

}



file "spec/spec_helper.rb", %q{# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(Rails)
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Rspec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # If you'd prefer not to run each of your examples within a transaction,
  # uncomment the following line.
  # config.use_transactional_examples = false
end
}

file "spec/controllers/main_controller_spec.rb", %q{require 'spec_helper'

describe MainController do

  it "should show main page" do
    get 'index'
    response.should be_success
  end

end
}



# Routes
route "root :to => 'main#index'"

# Initialize git repository
#git :init
#git :add => "."
#git :commit => "-a -m 'Initial commit'"

