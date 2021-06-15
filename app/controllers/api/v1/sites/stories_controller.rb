module Api
  module V1
    module Sites
      class StoriesController < BaseApiController
        def index
          @stories = Story.where(published: true)
          render json: { stories: @stories }
        end

        def show
          @story = Story.find(params[:id])
          render json: { story: @story }
        end
      end
    end
  end
end
