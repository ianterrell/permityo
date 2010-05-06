class DummyBetaController < ApplicationController
  permit "noone"
  attr_accessor :logged_in_user
  
  def index
  end

protected
  def current_user
    @logged_in_user
  end
  
  def login_required_redirection
    "/controller_specified_login"
  end
  
  def permission_denied_redirection
    "/controller_specified_permission_denied"
  end
end
