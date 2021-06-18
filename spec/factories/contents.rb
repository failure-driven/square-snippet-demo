FactoryBot.define do
  factory :content, class: "Content" do
    content_title { "my content title" }
    description { "the description" }
    url { "the url" }
  end
end
