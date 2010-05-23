require 'spec_helper'

describe MainController do

  it "should show main page" do
    get 'index'
    response.should be_success
  end

end
