module Sites
  class ContentsController < ApplicationController
    before_action :authenticate_user!

    def new
      @site = Site.find_by(reference_id: params[:site_id])
      @story = Story.find(params[:story_id])
      @content = Content.new
    end

    def create
      @story = Story.find(params[:story_id])
      Content.create!(content_params.merge(story: @story))

      flash[:info] = "Content successfully created"
      redirect_to edit_site_story_path(params[:site_id], story)
    end

    def edit
      @site = Site.find_by(reference_id: params[:site_id])
      @content = Content.find(params[:id])
      authorised_to_access!(@content, :manage)
    end

    def update
      @content = Content.find(params[:id])
      @content.update!(content_params)

      flash[:info] = "Content successfully updated"
      redirect_to edit_site_story_path(params[:site_id], story)
    end

    def destroy
      @content = Content.find(params[:id])
      authorised_to_access!(@content, :manage)

      @content.destroy!

      flash[:info] = "Content successfully deleted"
      redirect_to edit_site_story_path(params[:site_id], story)
    end

    private

    def content_params
      params.require(:content).permit(:story_id, :content_title, :url, :published, :video_url, :video,
                                      attachments: [],)
    end

    def story
      @story ||= Story.find(params[:story_id])
    end
  end
end
