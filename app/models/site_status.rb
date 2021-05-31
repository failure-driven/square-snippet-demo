class SiteStatus
  STATUSES = %w[active deleted].freeze

  def initialize(status)
    @status = status
  end

  def to_s
    @status
  end
end
