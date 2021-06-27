module PageFragments
  module ConfigureSite
    def for_action(form_action)
      Support::Components::RailsForm.new(
        browser.find("form[action=\"#{form_action}\"]"),
      )
    end
  end
end
