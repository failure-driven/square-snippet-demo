json.stories @stories do |story|
  json.extract! story, :story_title
  json.extract! story, :id

  json.video_url story.contents.where(published: true).first.video_url
end
