class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)
    logger.debug "FB Data: #{request.env["omniauth.auth"]}"
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      if @user.confirmed_at > (Time.now - 1.minute)
        sign_in @user, :event => :authentication
        render :choose_password
      else
        sign_in_and_redirect @user, :event => :authentication
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end