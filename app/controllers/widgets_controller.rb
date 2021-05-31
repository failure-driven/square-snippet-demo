class WidgetsController < ApplicationController
  protect_from_forgery except: %i[vanillajs_demo bootstrap_demo]

  def show
    version = params[:id] if %w[vanillajs bootstrap react svelte].include? params[:id]
    @js_location = "/widgets/#{version}_demo.js"
    @js_location = Webpacker.manifest.lookup!("widget_demo_react.js") if version == "react"
    @js_location = svelte_widget_widgets_url if version == "svelte"
  end

  def svelte_widget
    redirect_to Webpacker.manifest.lookup!("widget_demo_svelte.js")
  end
end
