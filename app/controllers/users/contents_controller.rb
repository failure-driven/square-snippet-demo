module Users
  class ContentsController < ApplicationController
    before_action :authenticate_user!

    def new
      @story = Story.find(params[:story_id])
    end

    def create
      @story = Story.find(params[:story_id])

      Content.create!(content_params)

      flash[:info] = "Content successfully created"
      redirect_to edit_user_story_path(current_user, @story)
    end

    private

    def content_params
      params.permit(:story_id, :content_title, :description, :url)
    end
  end
end