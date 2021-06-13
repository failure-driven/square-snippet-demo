class Site < ApplicationRecord
  belongs_to :identity
  include ArrayToEnumHash
  # enum status: array_to_enum_hash(SiteStatus::STATUSES), _suffix: true

  DEFAULT_WIDGET_CONFIG = {
    "title" => "Shop with Friends",
    "visible" => true,
    "chat" => true,
    "call" => true,
    "background-color" => "#ffffff",
    "counter" => true,
    "iframe" => true,
    "portal" => true,
  }.freeze

  def status
    @status ||= SiteStatus.new(self[:status])
  end

  def widget_config
    DEFAULT_WIDGET_CONFIG.deep_merge(widget_config_overrides || {})
  end
end
