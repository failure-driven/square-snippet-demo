module PageFragments
  module Contents
    def title
      contents_panel.find("h4").text
    end

    def start_new_content
      contents_panel.find("a", text: "New Content").click
    end

    def form
      Support::Components::RailsForm.new(browser.find("[data-testid=content-form]"))
    end

    def list
      Support::Components::RailsList.new(
        browser.find("[data-testid=contents-list]"),
      ).list_items
    end

    def edit_content_with_title(text)
      contents_panel.find("li", text: text).find("a", text: "Edit").click
    end

    def delete_content_with_title(text)
      contents_panel.find("li", text: text).find("a", text: "Delete").click
    end

    private

    def contents_panel
      browser.find("[data-testid=contents-panel]")
    end
  end
end
