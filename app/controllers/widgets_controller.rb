class WidgetsController < ApplicationController
  protect_from_forgery except: :vanillajs_demo

  def show
    @version = params[:id] if %w[vanillajs].include? params[:id]
  end
end
