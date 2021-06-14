module PageFragments
  module Swif
    module Stories
      def list
        browser.find(".swif .swif-stories-list").find_all("li").map(&:text)
      end
    end
  end
end
