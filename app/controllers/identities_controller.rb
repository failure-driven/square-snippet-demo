class IdentitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :authorise_admin, only: [:toggle_feature]

  def index
    @identity = current_user.identities.first
    if @identity
      redirect_to identity_path(@identity.uid)
    elsif current_user.admin?
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

  def toggle_feature
    form_user
    portal = Flipper[flipper_params]

    if portal.enabled?(form_user)
      portal.disable(form_user)
      flash[:notice] = "Portal successfully disabled"
    else
      portal.enable(form_user)
      flash[:notice] = "Portal successfully enabled"
    end

    redirect_to action: :show
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

  private

  def flipper_params
    params.require(:feature).to_sym
  end

  def form_user
    identity = current_user.identity_scope.find_by(uid: params[:id])
    identity.user.becomes(FormUser)
  end
end
