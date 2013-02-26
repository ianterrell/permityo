require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

# This is mostly to make sure it's all wired up correctly.

describe DummyController do
  it "should allow dogooders to do good" do
    get :do_good
    response.should be_success
    response.body.should == "done!"
  end
  
  it "should not allow dogooders to do evil" do
    get :do_evil
    flash[:alert].should == "Permission denied. You cannot access the requested page."
    response.should redirect_to(Rails.application.config.permit_yo.permission_denied_redirection)
  end
  
  it "should know how to permit? things" do
    @group = Group.new :owner => (@user = User.new)
    DummyController.new.permit?("owner of :group", :user => @user, :group => @group).should be_true
    DummyController.new.permit?("owner of :group", :user => User.new, :group => @group).should be_false
  end
  it "should use instance variables if there" do
    get :have_instance_variables
    response.should be_success
    response.body.should == "done!"
  end


end