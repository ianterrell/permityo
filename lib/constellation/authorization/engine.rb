require 'constellation/authorization'
require 'rails'

module Constellation
  module Authorization
    class Engine < Rails::Engine
      config.constellation = ActiveSupport::OrderedOptions.new unless config.respond_to? :constellation
      config.constellation.authorization = ActiveSupport::OrderedOptions.new
      config.constellation.authorization.mixin = :default
      config.constellation.authorization.login_required_redirection = { :controller => 'session', :action => 'new' }
      config.constellation.authorization.permission_denied_redirection = ''
      config.constellation.authorization.store_location_method = :store_location
      config.constellation.authorization.current_user_method = :current_user
      
      
      initializer "constellation.authorization.default" do |app|
        ActionController::Base.send :include, Constellation::Authorization::Base
        ActionView::Base.send :include, Constellation::Authorization::Base::ControllerInstanceMethods
        if app.config.constellation.authorization.mixin == :default
          ActiveRecord::Base.send :include, 
            Constellation::Authorization::Default::UserExtensions, 
            Constellation::Authorization::Default::ModelExtensions 
        end
      end
    end
  end
end
