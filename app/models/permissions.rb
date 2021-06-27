class Permissions
  def initialize(user)
    @user = user
  end

  def allow_access_to?(resource, action = :any)
    if resource.is_a?(Story) && action == :manage
      resource.user.id == @user.id
    elsif resource.is_a?(Content) && action == :manage
      resource.story.user.id == @user.id
    else
      false
    end
  end
end
