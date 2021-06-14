module PageFragments
  module Stories
    def form
      Support::Components::RailsForm.new(browser.find(testid("new-story-form")))
    end
  end
end
