class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def square
    generic_callback("square")
  end

  def facebook
    generic_callback("facebook")
  end

  def generic_callback(provider) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @identity = Identity.unscoped.find_for_oauth request.env["omniauth.auth"]

    @user = @identity.user || current_user
    if @user.nil?
      @user = User.new(
        email: @identity.email || @identity.email_placeholder,
        password: Devise.friendly_token[0, 20],
      )
      @user.skip_confirmation!
      @user.save!
      @identity.update(user_id: @user.id)
    end

    @user.update(email: @identity.email) if @user.email.blank? && @identity.email

    if @user.persisted?
      @identity.update(user_id: @user.id, is_active: true)
      # This is because we've created the user manually, and Device expects a
      # FormUser class (with the validations)
      @user = FormUser.find @user.id
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end
end
