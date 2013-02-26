require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

describe DummyGammaController do  
  describe "for handling requests for HTML" do
    it "should use controller defined methods to handle login required redirection when available" do
      get :index
      response.status.should == 200
    end
  
    it "should use controller defined methods to handle permission denied redirection when available" do
      get :index
      response.status.should == 200
    end
  end

  describe "for handling requests for XML" do
    it "should use controller defined methods to handle login required redirection when available" do
      get :index, :format => "xml"
      response.status.should == 200
    end
  
    it "should use controller defined methods to handle permission denied redirection when available" do
      get :index, :format => "xml"
      response.status.should == 200
    end
  end

  describe "for handling requests for JSON" do
    it "should use controller defined methods to handle login required redirection when available" do
      get :index, :format => "json"
      response.status.should == 200
    end
  
    it "should use controller defined methods to handle permission denied redirection when available" do
      get :index, :format => "json"
      response.status.should == 200
    end
  end
  
  describe "for handling requests for JS" do
    it "should use controller defined methods to handle login required redirection when available" do
      get :index, :format => "js"
      response.status.should == 200
    end
  
    it "should use controller defined methods to handle permission denied redirection when available" do
      get :index, :format => "js"
      response.status.should == 200
    end
  end
  
end