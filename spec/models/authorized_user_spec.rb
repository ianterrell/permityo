require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe User do
  # For boolean fields on models, ActiveRecord defines the field? method.
  # This is a quick and easy way to give roles using boolean flags on your model.
  # Don't forget to mark the fields as attr_protected.
  describe "for boolean fields on the user" do
    it "should have a role if the flag set to true" do
      User.new(:admin => true).has_role?("admin").should be_true
    end

    it "should not have a role if the flag set to false" do
      User.new(:admin => false).has_role?("admin").should be_false
    end
  end
  
  # For anything more dynamic than a boolean field you can simply
  # define a method.
  describe "for methods on the user" do
    it "should have a role if the method returns true" do
      User.new.has_role?("dogooder").should be_true
    end

    it "should have a role if the method returns an object" do
      User.new.has_role?("returns_symbol").should be_true
    end
    
    it "should not have a role if the method returns false" do
      User.new.has_role?("doeviler").should be_false
    end
    
    it "should not have a role if the method returns nil" do
      User.new.has_role?("returns_nil").should be_false
    end
  end
end