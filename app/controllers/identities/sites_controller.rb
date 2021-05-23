module Identities
  class SitesController < ApplicationController
    before_action :authenticate_user!, except: %i[widget]

    def show
      @identity = current_user.identities.find_by(uid: params[:identity_id])
      render plain: "404 Not Found", status: 404 unless @identity
    end

    def show_site
      @identity = current_user.identities.find_by(uid: params[:identity_id])
      if @identity
        client = @identity.user.square_client
        @sites = {}
        if defined? client
          sites_api = client.sites
          result = sites_api.list_sites

          if result.success?
            @sites = result.data.sites
                           .filter { |site| site[:id] == params[:id] }
                           .map { |site| [site[:id], { site: site }] }.to_h
          elsif result.error?
            flash[:errors] = result.errors
          end

          @sites.each do |site_id, _values|
            snippets_api = client.snippets
            result = snippets_api.retrieve_snippet(site_id: site_id)
            if result.success?
              @sites[site_id][:snippet] = result.data.snippet
            elsif result.error?
              @sites[site_id][:errors] = result.errors
            end
          end
        end
        render partial: "show_sites"
      else
        flash.now[:error] = "Not Found"
        render plain: "404 Not Found", status: 404
      end
    end

    def add_widget
      @identity = current_user.identities.find_by(uid: params[:identity_id])
      if @identity
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
      @identity = current_user.identities.find_by(uid: params[:identity_id])
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

    def widget
      redirect_to Webpacker.manifest.lookup!('widget_demo_svelte.js')
    end
  end
end
