module PageFragments
  module Stories
    def title
      stories_panel.find("h4").text
    end

    def start_new_story
      stories_panel.find("a", text: "New Story").click
    end

    def form
      Support::Components::RailsForm.new(browser.find("[data-testid=new-story-form]"))
    end

    def list
      Support::Components::RailsList.new(
        browser.find("[data-testid=stories-list]"),
      ).list_items
    end

    def edit_story_with_title(text)
      stories_panel.find("li", text: text).find("a", text: "Edit").click
    end

    private

    def stories_panel
      browser.find("[data-testid=stories-panel]")
    end
  end
end
