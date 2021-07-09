require "fileutils"

# rubocop:disable Metrics/AbcSize
def download_image(browser, user_id_tmp_dir, img_index_filename)
  # browser.save_screenshot
  image_fetcher_js = IO.read(Rails.root.join("spec/support/image_fetcher.js"))
  img_srcs = browser
             .all("div[role=dialog]", wait: 0).last.all("img")
             .map { |img| img["src"] }
             .filter { |src| src.include?("1080x1080") }
  img_srcs.each do |img_src|
    sleep 1
    browser.visit(img_src)
    img_uri = URI.parse(browser.find("img")["src"])
    _img_filename = File.basename(img_uri.path)
    image_base64_encoded = browser.evaluate_script(image_fetcher_js)
    File.open(Rails.root.join(user_id_tmp_dir, img_index_filename), "wb") do |f|
      f.write(Base64.decode64(image_base64_encoded))
    end
  end
  sleep 1
end

namespace :content do
  desc "Make contnet for user content:for_users SOURCE_URL=... USER_IDS=a,b,c USER=... PASS=..."
  task for_users: :environment do
    source_url = ENV.fetch("SOURCE_URL")
    user_ids = ENV.fetch("USER_IDS").split(",")
    user = ENV.fetch("USER")
    pass = ENV.fetch("PASS")

    require "selenium-webdriver"
    require "capybara"
    # require Rails.root.join("spec/support/capybara.rb").to_s

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.javascript_driver = :chrome
    Capybara.configure do |config|
      config.default_max_wait_time = 10 # seconds
      config.default_driver = :selenium
    end

    browser = Capybara.current_session

    browser.visit source_url

    browser.find("input[name=username]").send_keys user
    browser.find("input[name=password]").send_keys pass
    browser.click_on("Log In")

    browser.click_on("Not Now")
    browser.click_on("Not Now")

    user_ids.map do |user_id|
      user_id_tmp_dir = "tmp/content/#{user_id}"
      FileUtils.mkdir_p user_id_tmp_dir
      (0..24).each do |image_index|
        img_index_filename = format("#{user_id}_%02d.png", image_index)
        browser.visit "#{source_url}/#{user_id}"
        sleep 1
        browser
          .all("a")
          .filter { |anchor| !anchor.all("img", wait: 0).empty? }[image_index]
          .all("div", wait: 0)
          .find { |d| d["innerHTML"] == "" }
          .click
        download_image(browser, user_id_tmp_dir, img_index_filename)
      rescue Selenium::WebDriver::Error::ElementClickInterceptedError => e
        div_class = e.message[/receive the click:.*class="(.*)"/i, 1]
        browser.all("a").filter do |anchor|
          !anchor.all("img", wait: 0).empty?
        end [image_index].find("div.#{div_class}", wait: 0).click

        download_image(browser, user_id_tmp_dir, img_index_filename)
      end
    end
  end
end
# rubocop:enable Metrics/AbcSize
