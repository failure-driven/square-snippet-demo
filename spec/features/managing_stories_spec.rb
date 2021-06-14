require "rails_helper"

describe "Managing Stories", js: true do
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
          site_title: "site-title-1",
        },
      ],
    )
  end

  it "allows users to add and manage their own stories" do
    When "a user is signed in" do
      visit root_path
      expect(find(".messages .alert").text).to eq "You need to sign in or sign up before continuing."
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
      find(".devise-form a", text: "Square").click
      expect(focus_on(:messages).success).to eq "Successfully authenticated from Square account."
      expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
    end

    And "they create a new story" do
      expect(focus_on(:nav).actions).to eq(["Stories", "Sign out"])
      focus_on(:nav).follow_link_for("Stories")
      expect(focus_on(:stories).title).to eq("My Stories")
      pending
      find("[data-testid=new-story-link]", text: "Stories").click
      expect(find("div [data-testid=page-title]")).to eq("New Story")

      focus_on(:stories).form.submit(
        {
          site: "site-title-1",
          story_title: "a story about a product",
          published: false,
        },
      )
    end

    Then "their stories are listed" do
      expect(
        find_all("[data-testid=story-list] .row").map { |row| row.find_all("div").map(&:text) },
      ).to eq([
                %w[id date name views draft],
              ])
    end

    When "the user views a story" do
      find(".story-item", text: "a story about a product").click
    end

    Then "story details are shown" do
      expect(find(".messages .alert").text).to eq "Story successfully created"
      expect(find("[data-testid=page-title]")).to eq("a story about a product")
      expect(focus_on(:stories).form.fields).to eq(
        {
          site: "site-title-1",
          story_title: "a story about a product",
          published: false,
        },
      )
    end

    When "new content is added to the story" do
      focus_on(:contents).form.submit(
        {
          content_title: "buying a product online",
          description: "how i bought my product online",
          url: "a link to photo/video of my content",
        },
      )
    end

    Then "the new content is shown are updated" do
      expect(find(".messages .alert").text).to eq "Content successfully created"
      expect(find("[data-testid=page-title]")).to eq("a story about a product")
      expect(focus_on(:contents).form.fields).to eq(
        {
          content_title: "buying a product online",
          description: "how i bought my product online",
          url: "a link to photo/video of my content",
        },
      )
    end

    When "the story is published" do
      find("[data-testid=edit-story-link]", text: "Edit").click
      focus_on(:stories).form.submit({ published: true })
    end

    Then "the story is shown as publish" do
      expect(find(".messages .alert").text).to eq "Story successfully published"
      expect(find("[data-testid=page-title]")).to eq("My Stories")
      expect(
        find_all("[data-testid=story-list] .row").map { |row| row.find_all("div").map(&:text) },
      ).to eq([
                %w[id date name views published],
              ])
    end
  end
end
