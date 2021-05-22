# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    # TODO: fetch sits in backgound job
    client = current_user.square_client
    @sites = {}
    if defined? client
      sites_api = client.sites
      result = sites_api.list_sites

      if result.success?
        @sites = result.data.sites.map { |site| [site[:id], { site: site }] }.to_h
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
  end
end
