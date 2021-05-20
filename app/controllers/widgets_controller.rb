class WidgetsController < ApplicationController
  protect_from_forgery except: %i[vanillajs_demo bootstrap_demo]

  def show
    version = params[:id] if %w[vanillajs bootstrap react].include? params[:id]
    @js_location = "/widgets/#{version}_demo.js"
    @js_location = Webpacker.manifest.lookup!("widget_demo_react.js") if version == "react"
  end
end
