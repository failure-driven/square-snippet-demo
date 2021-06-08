class HomeController < ApplicationController
  before_action :authenticate_user!, except: %i[terms privacy]

  def index
    @identity = current_user.identities.first
  end

  def terms
    company_details
    @update_date_tnc = "June 08, 2021"
  end
  
  def privacy
    company_details
    @update_date_privacy = "June 07, 2021"
  end

  private

  def company_details
    @website_address = "https://stg-swif.herokuapp.com/"
    @company_name = "Swif"
    @country_of_hosting = "USA"
    @privacy_country = "USA"
    @contact_detail_first = "_________"
    @contact_detail_second = "_________"
    @contact_detail_email = "email@address.com"
    @contact_detail_misc = "_________"
  end
end
