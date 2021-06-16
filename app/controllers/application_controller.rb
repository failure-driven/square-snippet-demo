class ApplicationController < ActionController::Base
  def authorise_admin
    return redirect_to root_path flash[:error] = "Unathorised" unless current_user.admin?
  end
end
