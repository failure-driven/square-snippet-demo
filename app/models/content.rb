class Content < ApplicationRecord
  belongs_to :story
  has_many_attached :attachments
end
