class Assignment < ApplicationRecord
  belongs_to :activity
  belongs_to :user

  enum :status, { not_started: 0, in_progress: 1, completed: 2 }

  validates :status, presence: true
  validates :activity_id, uniqueness: { scope: :user_id, message: "already assigned to this user" }
end
