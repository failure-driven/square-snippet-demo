namespace :sellers do
  desc "find sellers sellers:find"
  task find: :environment do
    query = '"copyright 2021" "powered by square"'
    sites = []
    (0..10).each do |offset|
      offset_param = offset.zero? ? "" : format("&start=%d0", offset)
      url = "https://www.google.com/search?q=#{CGI.escape(query)}#{offset_param}"
      doc = Nokogiri::HTML(URI.open(url)) # rubocop:disable Security/Open
      doc
        .css("a")
        .reject { |a| a.css("h3").empty? }
        .each do |a|
          title = a.text.encode("ASCII", "binary", invalid: :replace, undef: :replace, replace: "-")
          text = a.xpath("../..").text.encode("ASCII", "binary", invalid: :replace, undef: :replace, replace: "-")
          text = text.sub(title, "")
          sites << {
            title: title,
            text: text,
            link: a["href"][/http[^&]+/],
          }
        end
      sleep(1)
    end
    puts sites.to_json
  end
end
