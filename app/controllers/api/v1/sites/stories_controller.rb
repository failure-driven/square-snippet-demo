module Api
  module V1
    module Sites
      class StoriesController < BaseApiController
        def index
          @stories = Story.published_stories
          render json: { stories: @stories }
        end

        def show
          @story = Story.find(params[:id])
        end
      end
    end
  end
end
