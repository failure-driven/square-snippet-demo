class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @identity = current_user.identities.first
    if @identity
      redirect_to identity_path(@identity.uid)
    else
      render plain: "404 Not Found", status: 404
    end
  end

  def show
    @identity = current_user.identities.find_by(uid: params[:id])
    render plain: "404 Not Found", status: 404 unless @identity
  end

  def show_sites
    @identity = current_user.identities.find_by(uid: params[:id])
    if @identity
      client = @identity.user.square_client
      @sites = {}
      if defined? client
        sites_api = client.sites
        result = sites_api.list_sites

        if result.success?
          @sites = result.data.sites.map { |site| [site[:id], { site: site }] }.to_h
        elsif result.error?
          flash[:errors] = result.errors
        end
      end
      render partial: "show_sites"
    else
      render plain: "404 Not Found", status: 404
    end
  end
end
