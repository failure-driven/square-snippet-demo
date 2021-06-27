class Content < ApplicationRecord
  belongs_to :story
  has_many_attached :attachments
  has_one_attached :video

  def draft
    published ? "published" : "draft"
  end
end
