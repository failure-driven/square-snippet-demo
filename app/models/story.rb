class Story < ApplicationRecord
  def self.published_stories
    published_contents = Content.where(published: true)
    published_contents.map(&:story).uniq
  end

  belongs_to :user
  belongs_to :site
  has_many :contents, dependent: :destroy

  def content_count_message
    contents.empty? ? "no content" : contents.count
  end
end
