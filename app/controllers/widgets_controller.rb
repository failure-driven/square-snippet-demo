class WidgetsController < ApplicationController
  protect_from_forgery except: %i[vanillajs_demo bootstrap_demo]

  def show
    @version = params[:id] if %w[vanillajs bootstrap].include? params[:id]
  end
end
