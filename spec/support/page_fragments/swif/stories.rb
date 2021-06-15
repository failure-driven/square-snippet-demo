module PageFragments
  module Swif
    module Stories
      def list
        swif.find(".swif-stories-list").find_all("li").map(&:text)
      end

      def go_to_story(story_name)
        swif.find("a", text: story_name).click
      end

      private

      def swif
        browser.find(".swif")
      end
    end
  end
end
