class CanAccessFlipperUI
  def self.matches?(request)
    current_user = request.env["warden"].user
    current_user.user_actions&.dig("admin", "can_administer")
  end
end
