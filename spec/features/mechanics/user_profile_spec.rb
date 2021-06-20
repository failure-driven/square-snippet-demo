require "rails_helper"

describe "User profile", js: true do
  it "an influencer can signup" do
    When "an influcencer does an email only signup" do
      visit root_path
      focus_on(:nav).follow_link_for("Log in")
      click_on("Sign up")
      find(".devise-form h2", text: "Sign up")
      login_form = Support::Components::RailsForm.new(
        page.find("form[action=\"#{user_registration_path}\"]"),
      )
      login_form.submit("Email" => "influencer@email.com")
    end

    Then "they sign up successfully" do
      pending "1 click signup working"
      expect(focus_on(:messages).alert).to eq "Signed up successfully."
      expect(find("nav.navbar [data-testid=signin-name]").text).to eq "influencer@email.com"
    end
  end

  context "when an influencer exists" do
    before do
      @influencer = create(:user, email: "influencer@email.com", password: "1password", confirmed_at: Time.zone.now)
    end

    it "User can view and update their profile" do
      When "influcencer logs in" do
        visit root_path
        focus_on(:nav).follow_link_for("Log in")
        find(".devise-form h2", text: "Swif log in")
        login_form = Support::Components::RailsForm.new(
          page.find("form[action=\"#{new_user_session_path}\"]"),
        )
        login_form.submit("Email" => "influencer@email.com", "Password" => "1password")
      end

      Then "they can see their email in the nav" do
        expect(focus_on(:messages).alert).to eq "Signed in successfully."
        expect(find("nav.navbar [data-testid=signin-name]").text).to eq "influencer@email.com"
      end

      When "they look at their profile by clicking the email in the nav" do
        pending "a profile link"
        find("nav.navbar a", text: "influencer@email.com").click
      end

      Then "they see their current profile"
      # blank name
      # no image
      # no bio

      When "they edit their profile"
      # set name
      # set image
      # set bio

      Then "the profile is updated"

      And "they see their avatar and name in the nav bar, not the email"
    end
  end
end
