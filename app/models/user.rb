require "square"

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :omniauthable,
         omniauth_providers: %i[square]

  has_many :identities, dependent: :destroy

  def generate_jwt
    JWT.encode(
      {
        id: id,
        exp: 60.days.from_now.to_i,
      },
      Rails.application.credentials.secret_key_base,
    )
  end

  def square
    identities.find_by(provider: "square")
  end

  def square_client
    @square_client ||= Square::Client.new(access_token: square.accesstoken)
  end

  def identity_scope
    admin? ? Identity : identities
  end

  def admin?
    user_actions&.dig("admin", "can_administer")
  end
end
