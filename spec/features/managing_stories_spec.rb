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
    When "a user is signed in to swif.club" do
      visit root_path
      expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
      find(".devise-form a", text: "Square").click
      expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
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
        },
      )
    end

    Then "their stories are listed" do
      expect(focus_on(:messages).alert).to eq "Story successfully created"
      expect(focus_on(:stories).list).to eq(
        [
          ["site-title-1", "a story about a product", "no content", "Edit"],
        ],
      )
    end

    When "the user clicks 'edit' for a story" do
      focus_on(:stories).edit_story_with_title("a story about a product")
    end

    Then "story details are shown" do
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:stories).title).to eq("Edit Story")
      # TODO: pre-populate story fields on the edit view
      # expect(focus_on(:stories).form.text_value_for("site")).to eq("a story about a product")
      expect(focus_on(:stories).form.text_value_for("story_title")).to eq("a story about a product")
    end

    When "new content is added to the story" do
      focus_on(:contents).start_new_content
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:contents).title).to eq("New Content")

      focus_on(:contents).form.submit(
        {
          content_title: "buying MY product online",
          description: "how i bought A product online",
          url: "a link to photo/video of content",
          published: false,
        },
      )
    end

    Then "the new content is shown on the edit story page" do
      expect(focus_on(:messages).alert).to eq "Content successfully created"
      expect(focus_on(:stories).title).to eq("Edit Story")

      expect(focus_on(:contents).title).to eq("Contents")
      expect(focus_on(:contents).list).to eq(
        [
          ["buying MY product online", "how i bought A product online", "a link to photo/video of content", "draft", "Edit"],
        ],
      )
    end

    When "the user edits their new content" do
      focus_on(:contents).edit_content_with_title("buying MY product online")
      sleep(0.1) # the page changes too fast!
      expect(focus_on(:contents).title).to eq("Edit Content")
      expect(focus_on(:contents).form.fields).to eq(
        {
          "Content title" => { value: "buying MY product online" },
          "Description" => { value: "how i bought A product online" },
          "Url" => { value: "a link to photo/video of content" },
          "Published" => { value: "1" },
        },
      )

      focus_on(:contents).form.submit(
        {
          content_title: "buying a product online",
          description: "how i bought my product online",
          url: "a link to photo/video of my content",
          published: true,
        },
      )
    end

    Then "updates are shown" do
      expect(focus_on(:messages).alert).to eq "Content successfully updated"
      expect(focus_on(:contents).list).to eq(
        [
          ["buying a product online", "how i bought my product online", "a link to photo/video of my content", "published", "Edit"],
        ],
      )
    end

    When "the user visits their site test demo page and clicks SWiF" do
      visit test_demo_identity_site_path(identity_id: "123456", id: "id-1")
      focus_on(:swif, :widget).open
      expect(focus_on(:swif, :widget).header).to have_content "Shop with Friends"
    end

    Then "a story with published content is shown" do
      focus_on(:iframe).within do
        focus_on(:swif, :widget).go_to_stories
        expect(focus_on(:swif, :stories).list).to eq(["a story about a product"])
      end
    end

    When "the user clicks on a story" do
      focus_on(:iframe).within do
        focus_on(:swif, :stories).go_to_story("a story about a product")
      end
    end

    Then "it shows content for that story, newest first" do
      focus_on(:iframe).within do
        expect(focus_on(:swif, :story).title).to eq("a story about a product")
        expect(
          focus_on(:swif, :story).contents,
        ).to eq([["buying a product online", "how i bought my product online"]])
      end
    end
  end

  it "only renders published content in the widget" do
    When "a user is signed in to swif.club" do
      visit root_path
      expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
      expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
      find(".devise-form a", text: "Square").click
      expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
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
        },
      )
    end

    Then "their stories are listed" do
      expect(focus_on(:messages).alert).to eq "Story successfully created"
      expect(focus_on(:stories).list).to eq(
        [
          ["site-title-1", "a story about a product", "no content", "Edit"],
        ],
      )
    end

    When "the user visits their site test demo page and clicks SWiF" do
      visit test_demo_identity_site_path(identity_id: "123456", id: "id-1")
      focus_on(:swif, :widget).open
      expect(focus_on(:swif, :widget).header).to have_content "Shop with Friends"
    end

    Then "no stories are shown because there is no published content" do
      focus_on(:iframe).within do
        focus_on(:swif, :widget).go_to_stories
        expect(focus_on(:swif, :stories).no_stories_message).to eq("you aint got no stories bruh")
      end
    end
  end
end
