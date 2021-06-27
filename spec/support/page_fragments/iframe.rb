module PageFragments
  module Iframe
    def within
      browser.switch_to_frame(browser.find(".content-iframe"))
      yield
      browser.switch_to_frame(:parent)
    end
  end
end
