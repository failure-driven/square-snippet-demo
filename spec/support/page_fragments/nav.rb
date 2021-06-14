module PageFragments
  module Nav
    def actions
      navbar.find_all(".btn").map(&:text)
    end

    def follow_link_for(text)
      navbar.find("a", text: text).click
    end

    private

    def navbar
      browser.find(".navbar")
    end
  end
end
