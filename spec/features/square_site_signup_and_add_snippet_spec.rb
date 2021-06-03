require "rails_helper"

describe "Square site signs up and adds a snippet to thier site", js: true do
  before do
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:square] = OmniAuth::AuthHash.new(
      provider: "square",
      uid: "123456",
      info: {
        name: "square-name",
        email: "square@email.com",
        nickname: "square-nickname",
        image: "square-image",
        phone: "square-phone",
        urls: "square-urls",
      },
      credentials: {
        token: "square-token",
        refresh_token: "square-refresh-token",
      },
    )
    Support::Fakes::Square.new(
      self,
      sites: [
        {
          id: "id-1",
          site_title: "title-1",
        },
        {
          id: "id-B",
          site_title: "title-B",
        },
      ],
    )
  end

  it "Square OAuth signup and load snippet with default configuration" do
    Given "the landing page" do
      visit root_path
      # TODO: describe the landing page
    end

    Then "they are informed they need to signup" do
      expect(find(".messages .alert").text).to eq "You need to sign in or sign up before continuing."
    end

    And "the only way to do that is with square" do
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
    end

    When "Square user signs up" do
      find(".devise-form a", text: "Square").click
    end

    Then "They are successfully signed up" do
      expect(find(".messages .alert").text).to eq "Successfully authenticated from Square account."
      expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
      expect(find_all(".breadcrumb .breadcrumb-item").map(&:text)).to eq(%w[Home square-name])
    end

    And "see their user and sites listed" do
      expect(
        find_all("[data-testid=site-list] .row").map { |row| row.find_all("div").map(&:text) },
      ).to eq([
                ["title-1", "id-1", "status:active", ""],
                ["title-B", "id-B", "status:active", ""],
              ])
    end

    When "They look at their first site"
    Then "they see it has no snippet configured"
    When "they add the snippet"
    Then "they see a success message"
    When "they visit their site"
    Then "they can interact with the widget"
    When "they look at stats on swif.club"
    Then "they see the results of their interaction"
    When "they change configuration of their widget"
    And "visit their site"
    Then "they see the re configured widget"
    When "they remove the widget"
    Then "it successfully is removed"
  end

  scenario "Square OAuth signs up but has no sites of their own yet"
  scenario "Square OAuth configures their snippet"
  scenario "Square OAuth user deactivates their account"
  scenario "non square site signs up to use the snippet code"
end
