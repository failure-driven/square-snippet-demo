# frozen_string_literal: true

class Site < ActiveRecord::Base
  belongs_to :identity
  include ArrayToEnumHash
  # enum status: array_to_enum_hash(SiteStatus::STATUSES), _suffix: true

  DEFAULT_WIDGET_CONFIG = {
    "title" => "Shop with Friends"
  }.freeze

  def status
    @status ||= SiteStatus.new(read_attribute(:status))
  end

  def widget_config
    DEFAULT_WIDGET_CONFIG.deep_merge(widget_config_overrides || {})
  end
end