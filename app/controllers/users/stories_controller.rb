module Users
  class StoriesController < ApplicationController
    before_action :authenticate_user!

    def index; end

    def new
      @current_user = current_user
      @sites = Site.all
    end
  end
end
