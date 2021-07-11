module PageFragments
  module Iframe
    def within
      browser.switch_to_frame(browser.find("#swifFrame-container-localhost iframe"))
      yield
      browser.switch_to_frame(:parent)
    end
  end
end
