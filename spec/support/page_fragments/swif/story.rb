module PageFragments
  module Swif
    module Story
      def title
        swif.find(".swif-story-title").text
      end

      def contents
        swif.find(".swif-contents-list").find_all("li").map { |li| li.text.split("\n") }
      end

      private

      def swif
        browser.find(".swif")
      end
    end
  end
end
