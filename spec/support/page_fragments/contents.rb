module PageFragments
  module Contents
    def form
      Support::Components::RailsForm.new(browser.find(testid("new-content-form")))
    end
  end
end
