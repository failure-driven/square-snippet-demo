class Story < ApplicationRecord
  belongs_to :user
  belongs_to :site
  has_many :contents, dependent: :destroy

  def draft
    published ? "published" : "draft"
  end
end
