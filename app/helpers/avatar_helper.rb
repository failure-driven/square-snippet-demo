module AvatarHelper
  def avatar_path(object, options = {})
    size = options[:size] || 180
    default_image = options[:default] || "mp"
    base_url = "https://secure.gravatar.com/avatar"
    base_url_params = "?s=#{size}&d=#{default_image}"

    if respond_to_avatar?(object)
      object.avatar.variant(resize_to_fill: [size, size, { gravity: "Center" }])
    elsif respond_to_email?(object)
      gravatar_id = Digest::MD5.hexdigest(object.email.downcase)
      "#{base_url}/#{gravatar_id}#{base_url_params}"
    end
  end

  def respond_to_avatar?(object)
    object.respond_to?(:avatar) && object.avatar.attached? && object.avatar.variable?
  end

  def respond_to_email?(object)
    object.respond_to?(:email) && object.email
  end
end
