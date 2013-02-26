require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe DummyBetaController do  
  describe "for handling normal requests for HTML" do
    it "should set the flash and redirect when not logged in" do
      @controller.logged_in_user = nil
      get :index
      flash[:alert].should == "Login is required to access the requested page."
      response.should redirect_to("/controller_specified_login")
    end
  
    it "should set the flash and redirect when unauthorized" do
      @controller.logged_in_user = User.new
      get :index
      flash[:alert].should == "Permission denied. You cannot access the requested page."
      response.should redirect_to("/controller_specified_permission_denied")
    end
  end
  
  describe "for handling requests for XML" do
    it "should not set the flash and should return a blank body with a 401 code when not logged in" do
      @controller.logged_in_user = nil
      get :index, :format => "xml"
      response.status.should == 401
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  
    it "should not set the flash and should return a blank body with a 403 code when unauthorized" do
      @controller.logged_in_user = User.new
      get :index, :format => "xml"
      response.status.should == 403
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  end
  
  describe "for handling requests for JSON" do
    it "should not set the flash and should return a blank body with a 401 code when not logged in" do
      @controller.logged_in_user = nil
      get :index, :format => "json"
      response.status.should == 401
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  
    it "should not set the flash and should return a blank body with a 403 code when unauthorized" do
      @controller.logged_in_user = User.new
      get :index, :format => "json"
      response.status.should == 403
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  end
  
  describe "for handling requests over xhr" do
    it "should not set the flash and should return a blank body with a 401 code when not logged in" do
      @controller.logged_in_user = nil
      xhr :get, :index, :format => "js"
      response.status.should == 401
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  
    it "should not set the flash and should return a blank body with a 403 code when unauthorized" do
      @controller.logged_in_user = User.new
      xhr :get, :index, :format => "js"
      response.status.should == 403
      response.body.should be_blank
      flash[:alert].should be_nil
    end
  end
  
end