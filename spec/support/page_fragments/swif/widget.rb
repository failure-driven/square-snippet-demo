module PageFragments
  module Swif
    module Widget
      def open
        browser.find("button.swif").click
      end

      def header
        browser.find(".swif .header-wrapper", visible: :all).text
      end

      def go_to_stories
        browser.find(".swif-stories-link").click
      end
    end
  end
end
