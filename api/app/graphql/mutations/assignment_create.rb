module Mutations
  class AssignmentCreate < BaseMutation
    field :assignment, Types::AssignmentType
    field :errors, [String], null: false

    argument :activity_id, ID, required: true

    def resolve(activity_id:)
      activity = GlobalID.find(activity_id)

      assignment = Assignment.new(
        activity: activity,
        user: context[:current_user],
        status: :not_started
      )

      if assignment.save
        { assignment: assignment, errors: [] }
      else
        { assignment: nil, errors: assignment.errors.full_messages }
      end
    end
  end
end
