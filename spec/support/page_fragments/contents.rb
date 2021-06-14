module PageFragments
  module Contents
    def title
      contents_panel.find("h4").text
    end

    def start_new_content
      contents_panel.find("a", text: "New Content").click
    end

    def form
      Support::Components::RailsForm.new(browser.find("[data-testid=new-content-form]"))
    end

    def list
      Support::Components::RailsList.new(
        browser.find("[data-testid=contents-list]"),
      ).list_items
    end

    private

    def contents_panel
      browser.find("[data-testid=contents-panel]")
    end
  end
end
