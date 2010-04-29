class DummyController < ApplicationController
  permit "dogooder", :only => :do_good
  permit "doeviler", :only => :do_evil
    
  def do_good
    render :text => "done!"
  end
  
  def do_evil
    render :text => "done! ...sigh."
  end  

protected
  def current_user
    User.new
  end
end
