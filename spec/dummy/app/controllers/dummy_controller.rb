class DummyController < ApplicationController
  
  before_filter :set_the_instance_variable

  permit "dogooder", :only => :do_good
  permit "doeviler", :only => :do_evil
  permit "owner of variable", :only => :have_instance_variables
    
  class Ownership
    def accepts_role?(role, user)
      return true
    end
  end

  def do_good
    render :text => "done!"
  end
  
  def do_evil
    render :text => "done! ...sigh."
  end  

  def have_instance_variables
    render :text => "done!"
  end

protected
  def current_user
    User.new
  end

  def set_the_instance_variable
    @variable = Ownership.new 
  end

end
