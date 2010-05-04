require 'constellation/authorization'
require 'rails'
require 'action_controller'
require 'action_view'

module Constellation
  module Authorization
    class Engine < Rails::Engine
      config.constellation = ActiveSupport::OrderedOptions.new unless config.respond_to? :constellation
      config.constellation.authorization = ActiveSupport::OrderedOptions.new
      config.constellation.authorization.root = __FILE__.gsub('/lib/constellation/authorization/engine.rb', '')
      config.constellation.authorization.implementation = :default
      config.constellation.authorization.login_required_redirection = { :controller => 'user_sessions', :action => 'new' }
      config.constellation.authorization.permission_denied_redirection = ''
      config.constellation.authorization.store_location_method = :store_location
      config.constellation.authorization.current_user_method = :current_user
      config.constellation.authorization.login_required_flash = :notice
      config.constellation.authorization.permission_denied_flash = :notice
      
      initializer "constellation.authorization.default" do |app|
        ActionController::Base.send :include, Constellation::Authorization::Base
        ActionView::Base.send :include, Constellation::Authorization::Base::ControllerInstanceMethods
        if app.config.constellation.authorization.implementation == :default
          require 'active_record'
          ActiveRecord::Base.send :include, 
            Constellation::Authorization::Default::UserExtensions, 
            Constellation::Authorization::Default::ModelExtensions 
        end
      end
    end
  end
end
