class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :admin?, only: [:admin, :admin_generator]

  def index
    @identity = current_user.identities.first
  end

  def admin; end

  def admin_generator
    flash[:success] = "YOLO"
    redirect_to admin_path
  end

  private

  def admin?
    redirect_to root_path flash[:error] = "Unathorised" unless current_user.user_actions&.dig("admin", "can_administer")
  end
end
