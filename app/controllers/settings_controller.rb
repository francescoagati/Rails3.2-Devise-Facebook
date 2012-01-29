class SettingsController < Devise::RegistrationsController
  def edit
    @user = current_user
  end
  
  def update
    @user = User.find(@user.id)
    if @user.update_attributes(params[:user])
      # Sign in the user by passing validation in case his password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end
end