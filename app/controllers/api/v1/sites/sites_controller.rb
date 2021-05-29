module Api
  module V1
    module Sites
      class SitesController < BaseApiController
        def visit_count
          site = Site.find_by(domain: params[:domain])
          render json: { visit_count: site.visit_count }
        end

        def update_visit_count
          site = Site.find_by(domain: params[:domain])
          site.update!(visit_count: site.visit_count + 1)
          render json: { visit_count: site.visit_count }
        end
      end
    end
  end
end