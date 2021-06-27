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
    "counter" => false,
    "portal" => true,
    "zoid_portal" => false,
  }.freeze

  SITE_TIMESTAMP_FIELDS = %i[created_at updated_at].freeze
  API_VALID_FIELDS = %i[
    site_title
    domain
    is_published
    created_at
    updated_at
  ].freeze

  default_scope { where.not(status: :deleted).order(is_published: :desc).order(site_title: :asc) }
  scope :active, -> { where(is_published: true).order(site_title: :asc) }
  scope :live, -> { where(is_published: true).order(site_title: :asc) }

  def status
    @status ||= SiteStatus.new(self[:status])
  end

  def widget_config
    DEFAULT_WIDGET_CONFIG.deep_merge(widget_config_overrides || {})
  end

  def last_published
    return "deleted" if domain.blank?
    return "unpublished" unless is_published?

    "last published on #{site_updated_at&.to_date&.to_s(:long)} to #{domain}"
  end

  class << self
    def find_or_update_by_api_result(identity, sites)
      sites.each do |site_result|
        site = Site.unscoped.find_or_initialize_by(reference_id: site_result[:id], identity: identity)
        site.update!(site_args_for(identity, site_result))
        site.update!(status: "deleted") if !site.is_published? && site.domain&.empty?
      end
      deleted_sites = identity.sites.where.not(reference_id: sites.pluck(:id))
      deleted_sites.update(status: "deleted")
    end

    private

    def site_args_for(identity, site_result)
      site_args = site_result
                  .slice(*API_VALID_FIELDS)
                  .map { |key, value| map_fields(key, value) }
                  .to_h
      site_args[:identity] = identity
      site_args[:status] = "active"
      site_args
    end

    def map_fields(key, value)
      return ["site_#{key}", value] if SITE_TIMESTAMP_FIELDS.include?(key)

      [key, value]
    end
  end
end
