class RegistrationsController < Devise::RegistrationsController
  def update_resource(resource, params) # rubocop:disable Metrics/AbcSize.
    if resource.encrypted_password.blank? # || params[:password].blank?
      resource.email = params[:email] if params[:email]
      if params[:password].present? && params[:password] == params[:password_confirmation]
        logger.info "Updating password"
        resource.password = params[:password]
        resource.save
      end
      resource.update_without_password(params) if resource.valid?
    else
      resource.update_with_password(params)
    end
  end
end
