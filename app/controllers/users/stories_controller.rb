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
    end

    def edit
      @sites = Site.all
      @story = Story.find(params[:id])
    end

    def update; end

    private

    def story_params
      params.permit(:site_id, :story_title, :published, :user_id)
    end
  end
end
