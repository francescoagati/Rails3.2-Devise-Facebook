class RegistrationsController < Devise::RegistrationsController
  
  def update
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)

      if resource.update_with_password(params[resource_name], current_user.id, params[:facebook])
        if is_navigational_format?
          if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
            flash_key = :update_needs_confirmation
          end
          set_flash_message :notice, flash_key || :updated
        end
        sign_in resource_name, resource, :bypass => true
        respond_with resource, :location => after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end  
  
  def choose_pass
    render :choose_password
  end

  protected

    def after_update_path_for(resource)
      root_path
      #user_path(resource)
    end
end