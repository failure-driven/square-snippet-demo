require "rails_helper"

describe "User landing pages", js: true do
  it "User is informed about swiffing and encouraged to log in with square" do
    When "a user want's to swif" do
      visit root_path
    end

    Then "they see all the relevant marketing material" do
      expect(
        page,
      ).to have_content "Swif"
    end

    And "a message to log in" do
      expect(focus_on(:messages).alert).to eq "You need to sign in or sign up before continuing."
    end

    And "a call to action to login with square" do
      expect(all(".devise-form a").map(&:text)).to contain_exactly("Square")
    end

    And "marketing information on why they should add swif to their powered by square site" do
      pending "marketing material"
      expect(page).to have_content "SWiF will accelerate your powered by Square store, get it now!"
    end
  end

  context "when user has a square account" do
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
    end

    it "User successfully signs in and is told to create a site" do
      When "a user signs" do
        visit root_path
        find(".devise-form a", text: "Square").click
      end

      Then "they are told they succeeded" do
        expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
      end

      And "told to create a square site to use swif" do
        pending "instructions on how to add swif to powered by Square"
        expect(page).to have_content "you need to create a powered by Square site to instal SWiF"
      end
    end

    context "when user has a site" do
      before do
        Support::Fakes::Square.new(
          self,
          sites: [
            {
              id: "site_ONE_SITE_ID",
              site_title: "My ONE SITE",
              domain: "My-ONE-SITE.square.site",
              is_published: true,
              updated_at: "2021-07-01T12:00:00",
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

      it "User successfully signs in landing on their only site" do
        When "a user signs" do
          visit root_path
          find(".devise-form a", text: "Square").click
        end

        Then "they successfully authenticate and land on their identity paget he first time" do
          expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
          expect(
            all(".breadcrumb .breadcrumb-item").map(&:text),
          ).to eq(%w[Home square-name])
        end

        When "they click SWiF to go home" do
          find("nav a.navbar-brand").click
        end

        Then "they go straight to their site page" do
          expect(
            page.document.synchronize do # NOTE: needed for following map reduce to work on active elements
              all(".breadcrumb .breadcrumb-item", count: 3).map(&:text) # NOTE: minimum 3 causes wait behaviour
            end,
          ).to eq(["Home", "square-name", "My ONE SITE"])
        end

        And "are shown their active site" do
          pending "display the default live site text"
          expect(page).to have_content "last published on July 01, 2021 to My-ONE-SITE.square.site"
        end
      end
    end

    context "when user has many sites" do
      before do
        Support::Fakes::Square.new(
          self,
          sites: [
            {
              id: "site_ONE_SITE_ID",
              site_title: "My ONE SITE",
              domain: "My-ONE-SITE.square.site",
              is_published: true,
              updated_at: "2021-07-01T12:00:00",
            },
            {
              id: "site_TWO_SITE_ID",
              site_title: "My TWO SITE",
              domain: "My-TWO-SITE.square.site",
              is_published: true,
              updated_at: "2021-01-01T00:00:00",
            },
          ],
        )
      end

      it "User successfully signs in being shown a list of sites" do
        When "a user signs" do
          visit root_path
          find(".devise-form a", text: "Square").click
        end

        And "are on their identity page listing both their sites" do
          expect(find_all(".breadcrumb .breadcrumb-item").map(&:text)).to eq(%w[Home square-name])
          expect(
            find_all("[data-testid=site-list] .row").map { |row| row.find_all("div").map(&:text) },
          ).to eq([
                    ["My ONE SITE", "last published on July 01, 2021 to My-ONE-SITE.square.site"],
                    ["My TWO SITE", "last published on January 01, 2021 to My-TWO-SITE.square.site"],
                  ])
        end
      end
    end

    context "when user has many sites, but only 1 active" do
      before do
        Support::Fakes::Square.new(
          self,
          sites: [
            {
              id: "site_DELETED_SOME_TIME_AGO",
              site_title: "DELETED SOME TIME AGO",
              is_published: false,
            },
            {
              id: "site_ACTIVE_NOT_PUBLISHED",
              site_title: "ACTIVE NOT PUBLISHED",
              domain: "active-not-published.square.site",
              is_published: false,
            },
            {
              id: "site_ACTIVE_AND_PUBLISHED",
              site_title: "ACTIVE AND PUBLISHED",
              domain: "active-and-published.square.site",
              is_published: true,
              updated_at: "2021-07-01T12:00:00",
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

      it "User successfully signs in being shown a list of sites" do
        When "a user signs" do
          visit root_path
          find(".devise-form a", text: "Square").click
        end

        Then "they successfully authenticate and land on their identity paget he first time" do
          expect(focus_on(:messages).alert).to eq "Successfully authenticated from Square account."
          expect(
            all(".breadcrumb .breadcrumb-item").map(&:text),
          ).to eq(%w[Home square-name])
        end

        When "they click SWiF to go home" do
          find("nav a.navbar-brand").click
        end

        Then "they are immediately taken to their only active site" do
          expect(
            all(".breadcrumb .breadcrumb-item", minimum: 3).map(&:text), # NOTE: minimum 3 causes wait behaviour
          ).to eq(["Home", "square-name", "ACTIVE AND PUBLISHED"])
        end

        When "they go up the breadcrumbs to view their whole account" do
          find("a", text: "square-name").click
          expect(
            page.document.synchronize do # NOTE: needed for following map reduce to work on active elements
              all(".breadcrumb .breadcrumb-item", count: 2).map(&:text) # NOTE: minimum 2 causes wait behaviour
            end,
          ).to eq(%w[Home square-name])
          pending "only admin being able to see deleted sites"
          expect(
            page.document.synchronize do # NOTE: needed for following map reduce to work on active elements
              find_all("[data-testid=site-list] .row").map { |row| row.find_all("div").map(&:text) }
            end,
          ).to eq([
                    ["ACTIVE AND PUBLISHED", "last published on July 01, 2021 to active-and-published.square.site"],
                    ["ACTIVE NOT PUBLISHED", "unpublished"],
                  ])
        end
      end
    end
  end
end
