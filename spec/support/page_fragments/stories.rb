module PageFragments
  module Stories
    def title
      stories_panel.find(".card-header").text
    end

    def form
      Support::Components::RailsForm.new(browser.find("[data-testid=new-story-form]"))
    end

    private

    def stories_panel
      browser.find("[data-testid=stories-panel]")
    end
  end
end
