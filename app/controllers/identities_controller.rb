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
    @sites = @identity
      .sites
      .map{|site| [site.reference_id, {site: site}]}
      .to_h
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
          result
            .data
            .sites
            .each do |site_result|
              site = Site
                .find_or_initialize_by(reference_id: site_result[:id], identity: @identity)
              site
                .update!(
                  site_result
                    .slice(*%i[site_title domain is_publised created_at updated_at])
                    .map{|key,value| %w[created_at updated_at].include?(key) ? ["site_#{key}", value] : [key, value]}
                    .to_h
                    .merge(
                      identity: @identity,
                      status: 'active'
                    )
                )
            end
        elsif result.error?
          flash[:errors] = result.errors
        end
        @sites = @identity
          .sites
          .map{|site| [site.reference_id, {site: site}]}
          .to_h
      end
      render partial: "show_sites"
    else
      render plain: "404 Not Found", status: 404
    end
  end
end
