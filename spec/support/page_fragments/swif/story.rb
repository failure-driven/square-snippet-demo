module PageFragments
  module Swif
    module Story
      def contents
        swif.find(".swif-contents-list").find_all("li").map(&:text)
      end

      private

      def swif
        browser.find(".swif")
      end
    end
  end
end
