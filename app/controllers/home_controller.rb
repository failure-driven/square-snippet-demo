class HomeController < ApplicationController
  before_action :set_company_details
  layout "landing", only: [:index]

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
end
