class Activity::MultipleChoice < ApplicationRecord
  self.table_name = "activity_multiple_choices"

  has_one :part, as: :partable,
          class_name: "Activity::Part",
          dependent: :destroy,
          inverse_of: :partable

  has_many :choices, -> { order(:position) },
           class_name: "Activity::MultipleChoice::Choice",
           foreign_key: :activity_multiple_choice_id,
           dependent: :destroy,
           inverse_of: :multiple_choice

  validates :prompt, presence: true
end
