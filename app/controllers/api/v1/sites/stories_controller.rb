module Api
  module V1
    module Sites
      class StoriesController < BaseApiController
        def index
          stories = []
          Content.where(published: true).map do |content|
            stories << content.story if content.story.site_id == params[:site_id]
          end

          render json: { stories: stories.uniq }
        end

        def show
          @story = Story.find(params[:id])
        end
      end
    end
  end
end
