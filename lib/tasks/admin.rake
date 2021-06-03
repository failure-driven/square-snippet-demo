VALID_FLIP_STATE = %w[enable disable].freeze

namespace :admin do
  desc "Make user admin admin:make_admin_user[email]"
  task :make_admin_user, [:email] => :environment do |_task, args|
    user = User.find_or_create_by(email: args[:email]) do |new_user|
      new_user.password = Devise.friendly_token[0, 20]
      new_user.skip_confirmation!
    end
    user.update!(
      user_actions: (user.user_actions || {}).merge(admin: { can_administer: true }),
    )

    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save

    if Rails.env.development?
      puts "http://localhost:3000/users/password/edit?reset_password_token=#{raw}"
    else
      puts "https://swif.club/users/password/edit?reset_password_token=#{raw}"
    end
  end

  desc "flip some features user admin:flipper[FEATURE_NAME,enable|disable] Identity_id_1 .. Indentity_id_N"
  task :flipper, %i[feature_name flip_state] => :environment do |_task, args|
    feature = args[:feature_name].to_sym
    flip_state = VALID_FLIP_STATE.include?(args[:flip_state]) && args[:flip_state]
    identity_ids = ENV.fetch("IDENTITIES").split(",")
    identity_ids.each do |uid|
      identity = Identity.find_by(uid: uid)
      user = identity.user.becomes(FormUser)
      Flipper[feature.to_sym].public_send(flip_state, user)
    end
  end
end
