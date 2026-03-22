module Mutations
  class AssignmentUpdate < BaseMutation
    field :assignment, Types::AssignmentType
    field :errors, [String], null: false

    argument :id, ID, required: true
    argument :status, Types::AssignmentStatusEnum, required: true

    def resolve(id:, status:)
      assignment = GlobalID.find(id)

      unless assignment.user_id == context[:current_user].id
        return { assignment: nil, errors: ["Not authorized"] }
      end

      if assignment.update(status: status)
        { assignment: assignment, errors: [] }
      else
        { assignment: nil, errors: assignment.errors.full_messages }
      end
    end
  end
end
