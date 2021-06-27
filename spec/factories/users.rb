FactoryBot.define do
  factory :user, class: "FormUser" do
    email { "square@email.com" }
    password { "password" }
  end
end
