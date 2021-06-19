module Identities
  # rubcop:disable Metrics/AbcSize
  class SitesController < ApplicationController # rubocop:disable Metrics/ClassLength
    before_action :authenticate_user!, except: %i[widget site_config portal]
    before_action :set_identity, except: %i[widget site_config portal]
    before_action :set_site, only: %i[show site_config stats configure_site_config]
    after_action :allow_iframe, only: %i[portal]

    def show
      @site = @identity.sites.where(reference_id: params[:id]).first
      render plain: "404 Not Found", status: :not_found unless @identity
      # TODO: make tests work with user_nav before turning it on
      if Flipper[:user_nav].enabled?(FormUser.find(@identity.user_id))
        render "show_with_user_nav"
      else
        render
      end
    end

    def show_site # rubocop:disable Metrics/AbcSize
      if @identity
        @site = @identity.sites.where(reference_id: params[:id]).first

        client = @identity.user.square_client
        snippets_api = client.snippets
        result = snippets_api.retrieve_snippet(site_id: @site.reference_id)
        if result.success?
          @snippet = result.data.snippet
        elsif result.error?
          if result.errors[0][:code] == "NOT_FOUND"
            @alert = "SWiF snippet not installed"
          else
            @errors = result.errors
          end
        end
        render partial: "show_sites"
      else
        flash.now[:error] = "Not Found"
        render plain: "404 Not Found", status: :not_found
      end
    end

    def add_widget # rubocop:disable Metrics/AbcSize.
      if @identity
        @site = @identity.sites.find_by(reference_id: params[:id])
        client = @identity.user.square_client
        if defined? client
          snippets_api = client.snippets
          site_id = params[:id]
          body = {}
          body[:snippet] = {}
          # NOTE: not required as only 1 can be added to a site
          #       https://developer.squareup.com/docs/snippets-api/use-the-api#upsert-snippet
          # body[:snippet][:id] = 'snippet_'
          body[:snippet][:site_id] = params[:id]
          body[:snippet][:content] = <<~EO_SNIPPET_CONTENT
            <script>
              var SwifStaticConfig = (function(my){
                my.data = () => {
                  return #{ {
                    site: @site.reference_id,
                    identity: @identity.uid,
                  }.to_json}
                }#{' '}
                return(my)
              })(SwifStaticConfig || {})
            </script>
            <script defer src="#{widget_identity_site_url}"></script>
          EO_SNIPPET_CONTENT

          result = snippets_api.upsert_snippet(site_id: site_id, body: body)

          if result.success?
            flash[:info] = "Widget successfully added"
            # Rails.logger.debug result.data
          elsif result.error?
            flash[:info] = "Failed to add widget: #{result.errors}"
          end
        end
        redirect_to action: :show
      else
        flash.now[:error] = "Not Found"
        render plain: "404 Not Found", status: :not_found
      end
    end

    def remove_widget # rubocop:disable Metrics/AbcSize.
      if @identity
        client = @identity.user.square_client
        if defined? client
          snippets_api = client.snippets
          site_id = params[:id]
          result = snippets_api.delete_snippet(site_id: site_id)

          if result.success?
            flash[:info] = "Widget successfully removed"
            # Rails.logger.debug result.data
          elsif result.error?
            flash[:info] = "Failed to add widget: #{result.errors}"
          end
          flash[:info] = "Widget successfully removed"
        end
        redirect_to action: :show
      else
        flash.now[:error] = "Not Found"
        render plain: "404 Not Found", status: :not_found
      end
    end

    def update
      @site = @identity.sites.where(reference_id: params[:id]).first
      widget_config_overrides = widget_config_overrides_permitted_params.to_h.transform_values do |v|
        %w[true false].include?(v.downcase) ? eval(v.downcase) : v # rubocop:disable Security/Eval
      end
      @site.update!(widget_config_overrides: widget_config_overrides)
    end

    def configure_site_config
      @config = @site.widget_config
    end

    def site_config
      @config = @site.widget_config
    end

    def stats; end

    def portal
      render layout: false
    end

    def widget
      redirect_to Webpacker.manifest.lookup!("widget_demo_svelte.js")
    end

    def test_demo
      @site = @identity.sites.where(reference_id: params[:id]).first
      @widget_snippet = <<~EO_SNIPPET_CONTENT
        <script>
          var SwifStaticConfig = (function(my){
            my.data = () => {
              return #{ {
                site: @site.reference_id,
                identity: @identity.uid,
              }.to_json}
            }#{' '}
            return(my)
          })(SwifStaticConfig || {})
        </script>
        <script defer src="#{widget_identity_site_url}"></script>
      EO_SNIPPET_CONTENT
    end

    private

    def set_identity
      @identity = current_user.identity_scope.find_by(uid: params[:identity_id])
    end

    def set_site
      @site = Site
              .where(identities: { uid: params[:identity_id] }, reference_id: params[:id])
              .joins(:identity)
              .first
    end

    def allow_iframe
      site = Site.find_by(reference_id: params[:id])
      response.headers["X-FRAME-OPTIONS"] = "ALLOW-FROM http://#{site.domain} https://#{site.domain}"
      # response.headers.delete "X-Frame-Options" # this would allow everyone
    end

    def widget_config_overrides_permitted_params
      params
        .require(:identity)
        .require(:site)
        .require(:widget_config_overrides)
        .permit!
    end
  end
end
