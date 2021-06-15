require "rails_helper"

describe "Managing Stories", js: true do
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
          site_title: "site-title-1",
        },
      ],
    )
  end

  it "allows users to add and manage their own stories" do
    When "a user is signed in" do
      visit root_path
      expect(focus_on(:messages).success).to eq "You need to sign in or sign up before continuing."
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
      find(".devise-form a", text: "Square").click
      expect(focus_on(:messages).success).to eq "Successfully authenticated from Square account."
      expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
    end

    And "they create a new story" do
      expect(focus_on(:nav).actions).to eq(["Stories", "Sign out"])

      focus_on(:nav).follow_link_for("Stories")
      expect(focus_on(:stories).title).to eq("My Stories")

      focus_on(:stories).start_new_story
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:stories).title).to eq("New Story")
      focus_on(:stories).form.submit(
        {
          # site_id: "site-title-1", #TODO this just happens to work because it's the first value in the select box
          story_title: "a story about a product",
          published: false,
        },
      )
    end

    Then "their stories are listed" do
      expect(focus_on(:messages).success).to eq "Story successfully created"
      expect(focus_on(:stories).list).to eq(
        [
          ["site-title-1", "a story about a product", "draft", "Edit"],
        ],
      )
    end

    When "the user edits a story" do
      focus_on(:stories).edit_story_with_title("a story about a product")
    end

    Then "story details are shown" do
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:stories).title).to eq("Edit Story")
      # expect(focus_on(:stories).form.fields).to eq(
      #   {
      #     site: "site-title-1",
      #     story_title: "a story about a product",
      #     published: false,
      #   },
      # ) #TODO pre-populate story fields on the edit view
    end

    When "new content is added to the story" do
      focus_on(:contents).start_new_content
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:contents).title).to eq("New Content")

      focus_on(:contents).form.submit(
        {
          content_title: "buying a product online",
          description: "how i bought my product online",
          url: "a link to photo/video of my content",
        },
      )
    end

    Then "the new content is shown are updated" do
      expect(focus_on(:messages).success).to eq "Content successfully created"
      expect(focus_on(:stories).title).to eq("Edit Story")

      expect(focus_on(:contents).title).to eq("Contents")
      expect(focus_on(:contents).list).to eq(
        [
          ["buying a product online", "how i bought my product online", "a link to photo/video of my content"],
        ],
      )
    end

    When "the story is published" do
      focus_on(:stories).form.submit(
        {
          # site_id: "site-title-1", #TODO this just happens to work because it's the first value in the select box
          story_title: "a story about a product",
          published: true,
        },
      )
    end

    Then "the story is shown as publish" do
      expect(focus_on(:messages).success).to eq "Story successfully saved"
      expect(focus_on(:stories).title).to eq("My Stories")
      expect(focus_on(:stories).list).to eq(
        [
          ["site-title-1", "a story about a product", "published", "Edit"],
        ],
      )
    end

    When "the user visits their site test demo page and clicks SWiF" do
      visit test_demo_identity_site_path(identity_id: "123456", id: "id-1")
      focus_on(:swif, :widget).open
      expect(focus_on(:swif, :widget).header).to have_content "Shop with Friends"
    end

    Then "a published story is shown" do
      focus_on(:iframe).within do
        focus_on(:swif, :widget).go_to_stories
        expect(focus_on(:swif, :stories).list).to eq(["a story about a product"])
      end
    end
  end
end
