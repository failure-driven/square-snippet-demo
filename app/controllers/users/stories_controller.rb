module Users
  class StoriesController < ApplicationController
    before_action :authenticate_user!

    def index
      @stories = Story.where(user: current_user)
    end

    def new
      @sites = Site.all
    end

    def create
      Story.create!(story_params)

      flash[:info] = "Story successfully created"
      redirect_to action: :index
    rescue ActiveRecord::RecordInvalid => e
      @sites = Site.all

      flash[:notice] = e.message
      render :new
    end

    def edit
      @sites = Site.all
      authorised_to_access!(story, :manage)
    end

    def update
      story.update!(story_params)

      flash[:info] = "Story successfully saved"
      redirect_to action: :index
    end

    def destroy
      authorised_to_access!(story, :manage)

      story.destroy!

      flash[:info] = "Story successfully deleted"
      redirect_to user_stories_path(current_user)
    end

    private

    def story_params
      params.permit(:site_id, :story_title, :published, :user_id)
    end

    def story
      @story ||= Story.find(params[:id])
    end
  end
end
