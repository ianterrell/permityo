require 'permit_yo'
require 'permit_yo/base'
require 'permit_yo/default'
require 'rails'
require 'action_controller'
require 'action_view'

module PermitYo
  class Engine < Rails::Engine
    config.permit_yo = ActiveSupport::OrderedOptions.new
    config.permit_yo.root = __FILE__.gsub('/lib/permit_yo/engine.rb', '')
    config.permit_yo.implementation = :default
    config.permit_yo.require_user_redirection = { :controller => 'user_sessions', :action => 'new' }
    config.permit_yo.permission_denied_redirection = ''
    config.permit_yo.store_location_method = :store_location
    config.permit_yo.current_user_method = :current_user
    config.permit_yo.require_user_flash = :alert
    config.permit_yo.permission_denied_flash = :alert
    
    initializer "permit_yo.default" do |app|
      ActionController::Base.send :include, PermitYo::Base
      ActionView::Base.send :include, PermitYo::Base::ControllerInstanceMethods
      if app.config.permit_yo.implementation == :default
        require 'active_record'
        ActiveRecord::Base.send :include, 
          PermitYo::Default::UserExtensions, 
          PermitYo::Default::ModelExtensions 
      end
    end
  end
end
