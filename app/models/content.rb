class Content < ApplicationRecord
  belongs_to :story
  has_many_attached :attachments

  def draft
    published ? "published" : "draft"
  end
end
