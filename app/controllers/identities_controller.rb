class IdentitiesController < ApplicationController
  before_action :authenticate_user!
  SITE_TIMESTAMP_FIELDS = %w[created_at updated_at].freeze

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
    @sites = @identity
             .sites
             .map { |site| [site.reference_id, { site: site }] }
             .to_h
    render plain: "404 Not Found", status: :not_found unless @identity
  end

  def toggle_portal
    return redirect_to root_path unless current_user.user_actions&.dig("admin", "can_administer")

    identity = current_user.identity_scope.find_by(uid: params[:id])
    user = identity.user.becomes(FormUser)
    portal = Flipper[flipper_params]
    if portal.enabled?(user)
      portal.disable(user)
      flash[:error] = "Portal successfully disabled"
    else
      portal.enable(user)
      flash[:notice] = "Portal successfully enabled"
    end
  end

  def show_sites # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    @identity = current_user.identity_scope.find_by(uid: params[:id])
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
                    .slice(*%i[site_title domain is_published created_at updated_at])
                    .map do |key, value|
                    # rubocop:disable Metrics/BlockNesting
                    if SITE_TIMESTAMP_FIELDS
                    .include?(key)
                      ["site_#{key}", value]
                    else
                      [key, value]
                    end
                    # rubocop:enable Metrics/BlockNesting
                  end
                    .to_h
                    .merge(
                      identity: @identity,
                      status: "active",
                    ),
                )
            end
          deleted_sites = @identity.sites.where.not(reference_id: result.data.sites.pluck(:id))
          deleted_sites.update(status: "deleted")
        elsif result.error?
          flash[:errors] = result.errors
        end
        @sites = @identity
                 .sites
                 .map { |site| [site.reference_id, { site: site }] }
                 .to_h
      end
      render partial: "show_sites"
    else
      render plain: "404 Not Found", status: :not_found
    end
  end

  private

  def flipper_params
    params.require(:portal).to_sym
  end
end
