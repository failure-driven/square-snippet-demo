require "rails_helper"

describe "Square site signs up and adds a snippet to thier site", js: true do
  around do |example|
    ENV["API_HOST_URL"] = "http://localhost:3001"
    example.run
    ENV["API_HOST_URL"] = nil
  end

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
      snippet_result: OpenStruct.new(
        success?: true,
        data: OpenStruct.new(
          snippet: {
            content: "the snippet content",
            created_at: "2021-07-12T12:00:00",
            updated_at: "2021-07-12T12:00:00",
          },
        ),
      ),
    )
  end

  it "Square OAuth signup and load snippet with default configuration" do
    Given "the landing page" do
      visit root_path
      # TODO: describe the landing page
    end

    Then "they are informed they need to signup" do
      expect(focus_on(:messages).success).to eq "You need to sign in or sign up before continuing."
    end

    And "the only way to do that is with square" do
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
    end

    When "Square user signs up" do
      find(".devise-form a", text: "Square").click
    end

    Then "They are successfully signed up" do
      expect(focus_on(:messages).success).to eq "Successfully authenticated from Square account."
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

    When "they check their configuration" do
      page.find("a", text: "title-1").click
      page.find("a", text: "Config").click
    end

    Then "they see the following config" do
      expect(
        focus_on(:configure_site)
          .for_action(identity_site_path(identity_id: "123456", id: "id-1"))
          .fields,
      ).to eq({
                "title" => { value: "Shop with Friends" },
                "visible" => { value: "true" },
                "chat" => { value: "true" },
                "call" => { value: "true" },
                "background-color" => { value: "#ffffff" },
                "counter" => { value: "true" },
                "portal" => { value: "true" },
              })
    end

    When "They look at their first site"
    Then "they see it has no snippet configured"
    When "they add the snippet"
    Then "they see a success message"
    When "they visit their site" do
      # TODO: is there a way to render 2 app mappings on 1 capybara app?
      # widget_contents = "<script>console.log('hello')</script>"
      # unless defined? MyRackWrapperApp
      #   MyRackWrapperApp = Rack::Builder.new do
      #     run lambda { |_env|
      #       [200, {}, [widget_contents]]
      #     }
      #   end
      # end
      # Capybara.app = MyRackWrapperApp
      # visit "/demo_site"
    end

    Then "they can interact with the widget"

    When "they visit their site test demo page and click swif" do
      visit test_demo_identity_site_path(identity_id: "123456", id: "id-1")
      page.find("button.swif").click
    end

    Then "they see the swif header" do
      expect(
        page.find(".swif .header-wrapper"),
      ).to have_content "Shop with Friends"
    end

    When "they configure their title text" do
      visit configure_site_config_identity_site_path(identity_id: "123456", id: "id-1")
      form = focus_on(:configure_site)
             .for_action(identity_site_path(identity_id: "123456", id: "id-1"))
      form.submit(
        "title" => "Custom Title",
      )
    end

    And "visit their test demo page and view swif" do
      visit test_demo_identity_site_path(identity_id: "123456", id: "id-1")
      page.find("button.swif").click
    end

    Then "they see the swif custom header" do
      expect(
        page.find(".swif .header-wrapper").text,
      ).to eq "Custom Title"
    end

    When "they look at stats on swif.club"
    Then "they see the results of their interaction"
    When "they change configuration of their widget"
    And "visit their site"
    Then "they see the re configured widget"
    When "they remove the widget"
    Then "it successfully is removed"

    Given "there is an admin on the system" do
      require "rake"
      Rake::Task.define_task(:environment)
      Rake.application.rake_require "tasks/admin"
      Rake::Task["admin:make_admin_user"].reenable
      Rake.application.invoke_task "admin:make_admin_user[m@m.m]"
    end

    And "no one is logged in and emails are clear" do
      page.find("a", text: "Sign out").click
      clear_emails
    end

    When "admin goes to reset their password as a way to log in" do
      visit new_user_password_path
      form = focus_on(:configure_site).for_action(user_password_path)
      form.submit("Email" => "m@m.m")
    end

    Then "admin is notified they will get an email" do
      expect(
        focus_on(:messages).success,
      ).to eq "You will receive an email with instructions on how to " \
              "reset your password in a few minutes."
    end

    And "they get an email" do
      open_email "m@m.m"
    end

    When "admin goes to change their passowrd" do
      current_email.click_link "Change my password"
      form = focus_on(:configure_site).for_action(user_password_path)
      form.submit(
        "New password" => "1password",
        "Confirm new password" => "1password",
      )
    end

    Then "they successfully login" do
      expect(
        focus_on(:messages).success,
      ).to eq "Your password has been changed successfully. " \
              "You are now signed in."
      expect(
        find("nav.navbar [data-testid=signin-name]").text,
      ).to eq "m@m.m"
    end

    And "they see a list of all users with accounts" do
      expect(
        all("[data-testid=user-list] .row")
          .map { |row| row.find_all("div").map(&:text) },
      ).to eq([
                ["123456", "square-name", "", ""],
              ])
    end
  end

  scenario "Square OAuth signs up but has no sites of their own yet"
  scenario "Square OAuth configures their snippet"
  scenario "Square OAuth user deactivates their account"
  scenario "non square site signs up to use the snippet code"
end
