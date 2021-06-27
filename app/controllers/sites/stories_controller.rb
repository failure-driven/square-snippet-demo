module Sites
  class StoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @site = Site.find_by(reference_id: params[:site_id])
      @stories = Story.where(user: current_user)
    end

    def new
      @site = Site.find_by(reference_id: params[:site_id])
      @story = Story.new
    end

    def create
      @site = Site.find_by(reference_id: params[:site_id])
      Story.create!(story_params.merge(site: @site, user: current_user))

      flash[:info] = "Story successfully created"
      redirect_to action: :index
    rescue ActiveRecord::RecordInvalid => e
      flash[:notice] = e.message
      render :new
    end

    def edit
      @site = Site.find_by(reference_id: params[:site_id])
      authorised_to_access!(story, :manage)
    end

    def update
      @site = Site.find_by(reference_id: params[:site_id])
      story.update!(story_params)

      flash[:info] = "Story successfully saved"
      redirect_to action: :index
    end

    def destroy
      authorised_to_access!(story, :manage)

      story.destroy!

      flash[:info] = "Story successfully deleted"
      redirect_to site_stories_path(params[:site_id])
    end

    private

    def story_params
      params.require(:story).permit(:site_id, :story_title, :published, :user_id, :story)
    end

    def story
      @story ||= Story.find(params[:id])
    end
  end
end
