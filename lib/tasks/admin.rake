namespace :admin do
  desc "Make user admin user:make_admin[email]"
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
end