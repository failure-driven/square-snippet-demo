class SitesController < ApplicationController
  def index
    @sites = Story.where(user: current_user).map(&:site)
  end

  def show; end
end
