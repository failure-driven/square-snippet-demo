module Users
  class ContentsController < ApplicationController
    before_action :authenticate_user!

    def new
      story
    end

    def create
      Content.create!(content_params)

      flash[:info] = "Content successfully created"
      redirect_to edit_user_story_path(current_user, story)
    end

    def edit
      @content = Content.find(params[:id])
      authorised_to_access!(@content, :manage)
    end

    def update
      @story = Story.find(params[:story_id])

      @content = Content.find(params[:id])
      @content.update!(content_params)

      flash[:info] = "Content successfully updated"
      redirect_to edit_user_story_path(current_user, story)
    end

    private

    def content_params
      params.permit(:story_id, :content_title, :description, :url, :published, :video_url, :video, attachments: [])
    end

    def story
      @story ||= Story.find(params[:story_id])
    end
  end
end
