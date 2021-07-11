module Api
  module V1
    module Sites
      class StoriesController < BaseApiController
        before_action :authenticate_user, only: :create

        def index
          @stories = []
          Content.where(published: true).map do |content|
            @stories << content.story if content.story.site.reference_id == params[:site_id]
          end
          render status: :ok
        end

        def show
          @story = Story.find(params[:id])
        end

        def create
          site = Site.find_by(reference_id: create_params[:site_id])
          ActiveRecord::Base.transaction do
            @story = Story.create!(
              user_id: @current_user_id,
              site: site,
              story_title: create_params[:title],
            )
            Content.create!(
              story: @story,
              content_title: create_params[:title],
              url: create_params[:url],
              published: true,
              video_url: create_params[:url],
            )
          end

          render status: :created
        end

        private

        def create_params
          params.require(:story).permit(:site_id, :title, :url)
        end
      end
    end
  end
end
