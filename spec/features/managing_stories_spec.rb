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

    @user = create(:user, email: "square@email.com", confirmed_at: Time.zone.now)
    @identity = create(:identity, user: @user, provider: "square", uid: "123456")
    @site = create(:site, identity: @identity, reference_id: "site_SQUARE_SITE_ID", status: "active")

    Support::Fakes::Square.new(
      self,
      sites: [
        {
          id: "site_SQUARE_SITE_ID",
          site_title: "my site title",
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
          ["my site title", "a story about a product", "no content", "Edit", "Delete"],
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
          ["buying MY product online", "how i bought A product online", "a link to photo/video of content", "draft", "Edit", "Delete"],
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
          "Video url" => { value: "" },
          "Video" => { value: "" },
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
          ["buying a product online", "how i bought my product online", "a link to photo/video of my content", "published", "Edit", "Delete"],
        ],
      )
    end

    When "the user visits their site test demo page and clicks SWiF" do
      visit test_demo_identity_site_path(identity_id: "123456", id: @site.reference_id)
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

    Then "it shows content for that story, newest first" do # TODO: implement the newest first part
      focus_on(:iframe).within do
        expect(focus_on(:swif, :story).title).to eq("a story about a product")
        expect(
          focus_on(:swif, :story).contents,
        ).to eq([["buying a product online", "how i bought my product online"]])
      end
    end
  end

  it "only renders stories with published content in the widget" do
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
          ["my site title", "a story about a product", "no content", "Edit", "Delete"],
        ],
      )
    end

    When "the user visits their site test demo page and clicks SWiF" do
      visit test_demo_identity_site_path(identity_id: "123456", id: @site.reference_id)
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

  context "when there is a story with published and unpublished content" do
    before do
      story = create(:story, site: @site, user: @user, story_title: "i have a story to tell")
      create(
        :content,
        story: story,
        content_title: "published content",
        description: "how i published a content",
        published: true,
      )
      create(:content, story: story, content_title: "NOT published content")
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

      And "visits their site test demo page and clicks SWiF" do
        visit test_demo_identity_site_path(identity_id: "123456", id: @site.reference_id)
        focus_on(:swif, :widget).open
        expect(focus_on(:swif, :widget).header).to have_content "Shop with Friends"
      end

      Then "their story is shown" do
        focus_on(:iframe).within do
          focus_on(:swif, :widget).go_to_stories
          expect(focus_on(:swif, :stories).list).to eq(["i have a story to tell"])
        end
      end

      When "they view the story" do
        focus_on(:iframe).within do
          focus_on(:swif, :stories).go_to_story("i have a story to tell")
        end
      end

      Then "only published content is shown" do
        focus_on(:iframe).within do
          expect(focus_on(:swif, :story).title).to eq("i have a story to tell")
          expect(
            focus_on(:swif, :story).contents,
          ).to eq([["published content", "how i published a content"]])
        end
      end
    end

    it "allows users to delete their contents and their story (which in turn that deletes any corresponding content)" do
      When "a user is signed in to swif.club" do
        visit root_path
        expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
        expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
        find(".devise-form a", text: "Square").click
        expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
        expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
      end

      And "they view their stories" do
        focus_on(:nav).follow_link_for("Stories")
        expect(focus_on(:stories).title).to eq("My Stories")
        expect(focus_on(:stories).list).to eq(
          [
            ["my site title", "i have a story to tell", "2", "Edit", "Delete"],
          ],
        )
      end

      When "they delete content for their story" do
        focus_on(:stories).edit_story_with_title("i have a story to tell")
        sleep(0.1)
        expect(focus_on(:stories).title).to eq("Edit Story")
        expect(focus_on(:contents).list).to eq(
          [
            ["published content", "how i published a content", "the url", "published", "Edit", "Delete"],
            ["NOT published content", "the description", "the url", "draft", "Edit", "Delete"],
          ],
        )
        focus_on(:contents).delete_content_with_title("how i published a content")
      end

      Then "the content is deleted" do
        expect(focus_on(:messages).alert).to eq "Content successfully deleted"
        expect(focus_on(:stories).title).to eq("Edit Story")
        expect(focus_on(:contents).list).to eq([["NOT published content", "the description", "the url", "draft", "Edit", "Delete"]]) # just 1 content
      end

      And "the story is shown to have fewer contents" do
        focus_on(:nav).follow_link_for("Stories")
        expect(focus_on(:stories).list).to eq([["my site title", "i have a story to tell", "1", "Edit", "Delete"]]) # story with content count == 1
      end

      When "they delete the story" do
        focus_on(:stories).delete_story_with_title("i have a story to tell")
      end

      Then "the story is deleted" do
        expect(focus_on(:messages).alert).to eq "Story successfully deleted"
        expect(focus_on(:stories).title).to eq("My Stories")
        expect(focus_on(:stories).list).to eq([])
      end

      And "associated contents in the db are deleted too" do
        expect(Content.count).to eq(0)
      end
    end
  end

  context "when there is a story created by another user" do
    before do
      @another_user = create(:user, email: "user2@email.com", confirmed_at: Time.zone.now)
      another_identity = create(:identity, user: @another_user, provider: "square", uid: "123457")
      another_site = create(:site, identity: another_identity, reference_id: another_identity.id, status: "active")
      @story = create(:story, site: another_site, user: @another_user, story_title: "i have a story to tell")
      @content = create(
        :content,
        story: @story,
        content_title: "published content",
        description: "how i published a content",
        published: true,
      )
    end

    it "only lets users manage the stories they have created" do
      When "a user is signed in to swif.club" do
        visit root_path
        expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
        expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
        find(".devise-form a", text: "Square").click
        expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
        expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
      end

      Then "they cannot see someone elses stories" do
        expect(focus_on(:nav).actions).to eq(["Stories", "Sign out"])

        focus_on(:nav).follow_link_for("Stories")
        expect(focus_on(:stories).title).to eq("My Stories")
        expect(focus_on(:stories).list).to eq([])
      end

      When "the user tries to edit someone else's story directly" do
        visit("users/#{@another_user.id}/stories/#{@story.id}/edit")
      end

      Then "they are booted back to the home page with an error" do
        expect(focus_on(:messages).alert).to eq("Sorry you do not have access to do that")
        expect(find_all(".breadcrumb .breadcrumb-item", count: 2).map(&:text)).to eq(%w[Home square-name])
      end

      When "the user tries to edit someone else's content directly" do
        visit("users/#{@another_user.id}/stories/#{@story.id}/contents/#{@content.id}/edit")
      end

      Then "they are booted back to the home page with an error" do
        expect(focus_on(:messages).alert).to eq("Sorry you do not have access to do that")
        expect(find_all(".breadcrumb .breadcrumb-item", count: 2).map(&:text)).to eq(%w[Home square-name])
      end
    end
  end

  context "when there is a second site with published stories too" do
    before do
      story = create(:story, site: @site, user: @user, story_title: "i have a story to tell")
      create(
        :content,
        story: story,
        content_title: "published content",
        description: "how i published a content",
        published: true,
      )

      @another_user = create(:user, email: "user2@email.com", confirmed_at: Time.zone.now)
      another_identity = create(:identity, user: @another_user, provider: "square", uid: "123457")
      another_site = create(:site, identity: another_identity, reference_id: another_identity.id, status: "active")
      @another_story = create(:story, site: another_site, user: @another_user, story_title: "another story")
      create(
        :content,
        story: @another_story,
        content_title: "another published content",
        description: "another how i published a content",
        published: true,
      )
    end

    it "does not render stories for other sites in the widget" do
      When "a user is signed in to swif.club" do
        visit root_path
        expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
        expect(find_all(".devise-form a").map(&:text)).to eq(["Square"])
        find(".devise-form a", text: "Square").click
        expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
        expect(find("nav.navbar [data-testid=signin-name]").text).to eq "square-name"
      end

      And "visits their site test demo page and clicks SWiF" do
        visit test_demo_identity_site_path(identity_id: "123456", id: @site.reference_id)
        focus_on(:swif, :widget).open
        expect(focus_on(:swif, :widget).header).to have_content "Shop with Friends"
      end

      Then "only published stories for the current site are shown" do
        focus_on(:iframe).within do
          focus_on(:swif, :widget).go_to_stories
          expect(focus_on(:swif, :stories).list).to eq(["i have a story to tell"])
        end
      end
    end
  end
end
