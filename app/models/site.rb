# frozen_string_literal: true

class Site < ActiveRecord::Base
  belongs_to :identity
  include ArrayToEnumHash
  # enum status: array_to_enum_hash(SiteStatus::STATUSES), _suffix: true

  def status
    @status ||= SiteStatus.new(read_attribute(:status))
  end
end