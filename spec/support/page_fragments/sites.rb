module PageFragments
  module Sites
    def title
      sites_panel.find("h3").text
    end

    private

    def sites_panel
      browser.find("[data-testid=sites-panel]")
    end
  end
end
