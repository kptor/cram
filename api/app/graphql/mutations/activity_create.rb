module Mutations
  class ActivityCreate < BaseMutation
    field :activity, Types::ActivityType
    field :errors, [String], null: false

    argument :title, String, required: true
    argument :description, String, required: false
    argument :parts, [Mutations::Inputs::ActivityPartInput], required: false

    def resolve(title:, description: nil, parts: [])
      activity = Activity.new(
        title: title,
        description: description,
        user: context[:current_user]
      )

      ActiveRecord::Base.transaction do
        activity.save!

        parts.each_with_index do |part_input, index|
          mc = Activity::MultipleChoice.create!(
            prompt: part_input[:prompt]
          )

          Activity::Part.create!(
            activity: activity,
            partable: mc,
            position: part_input[:position] || index
          )

          (part_input[:choices] || []).each_with_index do |choice, choice_index|
            Activity::MultipleChoice::Choice.create!(
              multiple_choice: mc,
              label: choice[:label],
              correct: choice[:correct] || false,
              position: choice[:position] || choice_index
            )
          end
        end
      end

      { activity: activity, errors: [] }
    rescue ActiveRecord::RecordInvalid => e
      { activity: nil, errors: e.record.errors.full_messages }
    end
  end
end
