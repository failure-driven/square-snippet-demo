module Identities
  class SitesController < ApplicationController
    before_action :authenticate_user!, except: %i[widget messenger]
    before_action :set_identity, except: %i[widget messenger]

    def show
      @site = { site: @identity.sites.where(reference_id: params[:id]).first }
      render plain: "404 Not Found", status: 404 unless @identity
    end

    def show_site
      if @identity
        @site = { site: @identity.sites.where(reference_id: params[:id]).first }

        client = @identity.user.square_client
        snippets_api = client.snippets
        result = snippets_api.retrieve_snippet(site_id: @site[:site].reference_id)
        if result.success?
          @site[:snippet] = result.data.snippet
        elsif result.error?
          @site[:errors] = result.errors
        end
        render partial: "show_sites"
      else
        flash.now[:error] = "Not Found"
        render plain: "404 Not Found", status: 404
      end
    end

    def add_widget
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
            var SwifWidgetConfig = (function(my){
              my.data = () => {
                return #{@site.widget_config.to_json}
              } 
              return(my)
            })(SwifWidgetConfig || {})
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
        render plain: "404 Not Found", status: 404
      end
    end

    def remove_widget
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
        render plain: "404 Not Found", status: 404
      end
    end

    def site_config
      @site = @identity.sites.find_by(reference_id: params[:id])
      @config = @site.widget_config
    end

    def messenger
      render :layout => false
    end

    def widget
      redirect_to Webpacker.manifest.lookup!('widget_demo_svelte.js')
    end

    private

    def set_identity
      @identity = current_user.identity_scope.find_by(uid: params[:identity_id])
    end
  end
end
