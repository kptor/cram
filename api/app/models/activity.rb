class Activity < ApplicationRecord
  belongs_to :user

  has_many :parts, -> { order(:position) },
           class_name: "Activity::Part",
           dependent: :destroy,
           inverse_of: :activity

  has_many :assignments, dependent: :destroy

  validates :title, presence: true
end
