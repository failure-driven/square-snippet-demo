module Api
  module V1
    module Sites
      class StoriesController < BaseApiController
        before_action :authenticate_user, only: :create

        def index
          stories = []
          Content.where(published: true).map do |content|
            stories << content.story if content.story.site.reference_id == params[:site_id]
          end

          render json: { stories: stories.uniq }
        end

        def show
          @story = Story.find(params[:id])
        end

        def create
          render json: {}
        end
      end
    end
  end
end
