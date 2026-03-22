class Activity::Part < ApplicationRecord
  self.table_name = "activity_parts"

  belongs_to :activity, inverse_of: :parts
  belongs_to :partable, polymorphic: true, dependent: :destroy

  validates :position, presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
