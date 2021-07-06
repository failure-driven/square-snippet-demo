module PageFragments
  module Swif
    module Stories
      def list
        swif.find(".swif-stories-list").find_all(".title").map(&:text)
      end

      def go_to_story(story_name)
        swif.find("a", text: story_name).click
      end

      def no_stories_message
        swif.find(".swif-no-stories").text
      end

      private

      def swif
        browser.find(".swif")
      end
    end
  end
end
