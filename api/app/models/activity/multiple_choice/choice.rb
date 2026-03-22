class Activity::MultipleChoice::Choice < ApplicationRecord
  self.table_name = "activity_multiple_choice_choices"

  belongs_to :multiple_choice, class_name: "Activity::MultipleChoice",
                               foreign_key: :activity_multiple_choice_id,
                               inverse_of: :choices

  validates :label, presence: true
  validates :position, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
