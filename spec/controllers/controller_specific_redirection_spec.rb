require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe DummyBetaController do  
  it "should redirect to a controller specified login required location when present in the controller" do
    @controller.logged_in_user = nil
    get :index
    response.should redirect_to("/controller_specified_login")
  end
  
  it "should redirect to a controller specified permission denied location when present in the controller" do
    @controller.logged_in_user = User.new
    get :index
    response.should redirect_to("/controller_specified_permission_denied")
  end
end