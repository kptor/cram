class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_many :activities, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :assigned_activities, through: :assignments, source: :activity
end
