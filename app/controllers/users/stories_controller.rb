module Users
  class StoriesController < ApplicationController
    before_action :authenticate_user!

    def index; end
  end
end
