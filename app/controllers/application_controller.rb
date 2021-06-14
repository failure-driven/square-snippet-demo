class ApplicationController < ActionController::Base
  def authorise_admin
    return redirect_to root_path flash[:error] = "Unathorised" unless admin?
  end

  private

  def admin?
    current_user.user_actions&.dig("admin", "can_administer")
  end
end
