module PageFragments
  module Messages
    def success
      browser.find(".messages .alert").text
    end
  end
end
