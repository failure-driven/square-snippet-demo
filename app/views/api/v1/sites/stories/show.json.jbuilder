json.story { json.extract! @story, :id, :story_title }

json.contents @story.contents do |content|
  json.extract! content, :id, :content_title, :description, :url
end
