class IdentitiesController < ApplicationController
  before_action :authenticate_user!

  def index
    @identity = current_user.identities.first
    if @identity
      redirect_to identity_path(@identity.uid)
    elsif current_user.user_actions&.dig("admin", "can_administer")
      @identities = Identity.all
    else
      render plain: "404 Not Found", status: :not_found
    end
  end

  def show
    @identity = current_user.identity_scope.find_by(uid: params[:id])
    @sites = @identity.sites
    render plain: "404 Not Found", status: :not_found unless @identity
  end

  def toggle_portal
    identity = current_user.identity_scope.find_by(uid: params[:id])
    user = identity.user.becomes(FormUser)
    portal = Flipper[params[:portal].to_sym]
    if portal.enabled?(user)
      portal.disable(user)
    else
      portal.enable(user)
    end
  end

  def show_sites # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @identity = current_user.identity_scope.find_by(uid: params[:id])
    if @identity
      client = @identity.user.square_client
      if defined? client
        sites_api = client.sites
        result = sites_api.list_sites

        if result.success? && !result.data.nil?
          Site.find_or_update_by_api_result(@identity, result.data.sites)
        elsif result.error?
          flash[:errors] = result.errors
        end
        @sites = @identity.sites
      end
      render partial: "show_sites"
    else
      render plain: "404 Not Found", status: :not_found
    end
  end
end
