require 'constellation/authorization/exceptions'
require 'constellation/authorization/parser'

module Constellation
  module Authorization
    module Base
      def self.included(recipient)
        recipient.extend ControllerClassMethods
        recipient.class_eval do
          include ControllerInstanceMethods
        end
      end

      module ControllerClassMethods

        # Allow class-level authorization check.
        # permit is used in a before_filter fashion and passes arguments to the before_filter.
        def permit(authorization_expression, *args)
          filter_keys = [:only, :except]
          filter_args, eval_args = {}, {}
          if args.last.is_a? Hash
            filter_args.merge!(args.last.reject {|k,v| not filter_keys.include? k })
            eval_args.merge!(args.last.reject {|k,v| filter_keys.include? k })
          end
          before_filter(filter_args) do |controller|
            controller.permit(authorization_expression, eval_args)
          end
        end
      end

      module ControllerInstanceMethods
        include Constellation::Authorization::Base::EvalParser  # RecursiveDescentParser is another option

        # Permit? turns off redirection by default and takes no blocks
        def permit?(authorization_expression, *args)
          @options = { :allow_guests => false, :redirect => false }
          @options.merge!(args.last.is_a?(Hash) ? args.last : {})

          has_permission?(authorization_expression)
        end

        # Allow method-level authorization checks.
        # permit (without a question mark ending) calls redirect on denial by default.
        # Specify :redirect => false to turn off redirection.
        def permit(authorization_expression, *args)
          @options = { :allow_guests => false, :redirect => true }
          @options.merge!(args.last.is_a?(Hash) ? args.last : {})

          if has_permission?(authorization_expression)
            yield if block_given?
          elsif @options[:redirect]
            handle_redirection
          end
        end

        private

        def has_permission?(authorization_expression)
          @current_user = get_user
          if not @options[:allow_guests]
            # We aren't logged in, or an exception has already been raised.
            # Test for both nil and :false symbol as restful_authentication plugin
            # will set current user to ':false' on a failed login (patch by Ho-Sheng Hsiao).
            # Latest incarnations of restful_authentication plugin set current user to false.
            if @current_user.nil? || @current_user == :false || @current_user == false
              return false
            elsif not @current_user.respond_to? :id
              raise(UserDoesntImplementID, "User doesn't implement #id")
            elsif not @current_user.respond_to? :has_role?
              raise(UserDoesntImplementRoles, "User doesn't implement #has_role?")
            end
          end
          parse_authorization_expression(authorization_expression)
        end

        # Handle redirection within permit if authorization is denied.
        def handle_redirection
          return if not self.respond_to?(:redirect_to)
          # Store url in session for return if this is available from authentication
          send(Rails.application.config.constellation.authorization.store_location_method) if respond_to?(Rails.application.config.constellation.authorization.store_location_method)
          if @current_user && @current_user != :false
            respond_to do |format|
              format.html do                
                if self.respond_to? :handle_permission_denied_redirection_for_html
                  handle_permission_denied_redirection_for_html
                else
                  flash[Rails.application.config.constellation.authorization.permission_denied_flash] = @options[:permission_denied_message] || t('constellation.authorization.permission_denied')
                  redirect_to @options[:permission_denied_redirection] || (self.respond_to?(:permission_denied_redirection) ? permission_denied_redirection : Rails.application.config.constellation.authorization.permission_denied_redirection)
                end
              end
              format.all do
                if self.respond_to? :"handle_permission_denied_redirection_for_#{params[:format]}"
                  self.send :"handle_permission_denied_redirection_for_#{params[:format]}"
                else
                  render :text => nil, :status => :forbidden
                end
              end
            end
          else
            respond_to do |format|
              format.html do
                if self.respond_to? :handle_require_user_redirection_for_html
                  handle_require_user_redirection_for_html
                else
                  flash[Rails.application.config.constellation.authorization.require_user_flash] = @options[:require_user_message] || t('constellation.authorization.require_user')
                  redirect_to @options[:require_user_redirection] || (self.respond_to?(:require_user_redirection) ? require_user_redirection : Rails.application.config.constellation.authorization.require_user_redirection) 
                end
              end
              format.all do
                if self.respond_to? :"handle_require_user_redirection_for_#{params[:format]}"
                  self.send :"handle_require_user_redirection_for_#{params[:format]}"
                else
                  render :text => nil, :status => :unauthorized
                end
              end
            end
          end
          false  # Want to short-circuit the filters
        end

        # Try to find current user by checking options hash and instance method in that order.
        def get_user
          if @options[:user]
            @options[:user]
          elsif @options[:get_user_method]
            send(@options[:get_user_method])
          elsif self.respond_to? Rails.application.config.constellation.authorization.current_user_method
            self.send Rails.application.config.constellation.authorization.current_user_method
          elsif not @options[:allow_guests]
            raise(CannotObtainUserObject, "Couldn't find ##{Rails.application.config.constellation.authorization.current_user_method} or @user, and nothing appropriate found in hash")
          end
        end

        # Try to find a model to query for permissions
        def get_model(str)
          if str =~ /\s*([A-Z]+\w*)\s*/
            # Handle model class
            begin
              Module.const_get(str)
            rescue
              raise CannotObtainModelClass, "Couldn't find model class: #{str}"
            end
          elsif str =~ /\s*:*(\w+)\s*/
            # Handle model instances
            model_name = $1
            model_symbol = model_name.to_sym
            if @options[model_symbol]
              @options[model_symbol]
            elsif instance_variables.include?('@'+model_name)
              instance_variable_get('@'+model_name)
            elsif respond_to?(model_symbol)
              send(model_symbol)
            else
              raise CannotObtainModelObject, "Couldn't find model (#{str}) in hash or as an instance variable"
            end
          end
        end
      end

    end
  end
end