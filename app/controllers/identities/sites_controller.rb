module Identities
  class SitesController < ApplicationController
    before_action :authenticate_user!

    def show
      @identity = current_user.identities.find_by(uid: params[:identity_id])
      unless @identity
        render plain: "404 Not Found", status: 404
      end
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
              .filter{|site| site[:id] == params[:id] }
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
        render plain: "404 Not Found", status: 404
      end
    end
  end
end
