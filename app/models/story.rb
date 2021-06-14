class Story < ApplicationRecord
  belongs_to :user
  belongs_to :site

  def draft
    published ? "published" : "draft"
  end
end
