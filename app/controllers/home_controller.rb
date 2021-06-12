class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i[terms privacy]
  before_action :set_company_details

  def index
    @identity = current_user.identities.first
  end

  private

  def terms; end

  def privacy; end

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
