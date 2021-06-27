module PageFragments
  module Messages
    def alert
      browser.find(".messages .alert").text
    end
  end
end
