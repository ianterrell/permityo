class DummyGammaController < ApplicationController
  permit "noone"
  
  def index
  end

protected
  def current_user
    User.new
  end

  def handle_require_user_redirection_for_html
    render :text => nil, :status => :ok
  end
  
  def handle_permission_denied_redirection_for_html
    render :text => nil, :status => :ok
  end

  def handle_require_user_redirection_for_xml
    render :text => nil, :status => :ok
  end
  
  def handle_permission_denied_redirection_for_xml
    render :text => nil, :status => :ok
  end
  
  def handle_require_user_redirection_for_json
    render :text => nil, :status => :ok
  end
  
  def handle_permission_denied_redirection_for_json
    render :text => nil, :status => :ok
  end
  
  def handle_require_user_redirection_for_js
    render :text => nil, :status => :ok
  end
  
  def handle_permission_denied_redirection_for_js
    render :text => nil, :status => :ok
  end
end
