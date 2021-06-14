class Story < ApplicationRecord
  belongs_to :user
  belongs_to :site
  has_many :contents

  def draft
    published ? "published" : "draft"
  end
end
