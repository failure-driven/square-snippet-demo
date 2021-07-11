FactoryBot.define do
  factory :content, class: "Content" do
    content_title { "my content title" }
    url { "the url" }
  end
end
