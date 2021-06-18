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
end
