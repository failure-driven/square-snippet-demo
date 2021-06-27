class ApplicationController < ActionController::Base
  rescue_from ForbiddenOperationError do |e|
    flash[:notice] = e.message
    redirect_to("/")
  end

  def authorise_admin
    return redirect_to root_path flash[:error] = "Unathorised" unless current_user.admin?
  end

  def authorised_to_access!(resource, action = :view, message = "Sorry you do not have access to do that")
    unless Permissions.new(current_user).allow_access_to?(resource, action)
      raise(
        ForbiddenOperationError,
        message,
      )
    end

    yield if block_given?
  end

  # TODO: demo code for authenticating via JWT
  #       using headers like
  #         headers: {
  #           "CONTENT-TYPE": "application/json",
  #           "AUTHORIZATION": `Token ${authToken}`,
  #         },
  #
  # def authenticate_user
  #   if request.headers["Authorization"].present?
  #     authenticate_user_with_token
  #   elsif params[:user_token]
  #     token = params[:user_token].presence
  #     @current_user_id = current_user_id_from_token(token)
  #   else
  #     authenticate_user!
  #   end
  # end

  # def authenticate_user_with_token
  #   authenticate_or_request_with_http_token do |token|
  #     @current_user_id = current_user_id_from_token(token)
  #   rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
  #     head :unauthorized
  #   end
  # end

  # def current_user_id_from_token(token)
  #   jwt_payload = JWT.decode(
  #     token,
  #     Rails.application.credentials.secret_key_base,
  #   ).first

  #   jwt_payload["id"]
  # end
end
