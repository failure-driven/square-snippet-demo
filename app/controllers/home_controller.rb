class HomeController < ApplicationController
  before_action :set_company_details
  before_action :authenticate_user!
  before_action :admin?, only: %i[admin admin_generator]

  def index
    redirect_to identities_path if current_user
  end

  private

  def set_company_details
    @website_address = "https://swif.club"
    @company_name = "Swif"
    @country_of_hosting = "USA"
    @privacy_country = "USA"
    @contact_detail_first = "_________"
    @contact_detail_second = "_________"
    @contact_detail_email = "swif.snippet@gmail.com"
    @contact_detail_misc = "_________"
    @update_date_tnc = "June 08, 2021"
    @update_date_privacy = "June 07, 2021"
  end

  def admin; end

  def admin_generator
    flash[:success] = "YOLO"
    redirect_to admin_path
  end

  def admin?
    redirect_to root_path flash[:error] = "Unathorised" unless current_user.user_actions&.dig("admin", "can_administer")
  end
end
