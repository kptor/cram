# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :activities, Types::ActivityType.connection_type, null: false,
          description: "List all activities"

    def activities
      Activity.all.order(created_at: :desc)
    end

    field :activity, Types::ActivityType, null: true,
          description: "Find an activity by ID" do
      argument :id, ID, required: true
    end

    def activity(id:)
      GlobalID.find(id)
    end

    field :my_assignments, Types::AssignmentType.connection_type, null: false,
          description: "Current user's assignments"

    def my_assignments
      context[:current_user].assignments.order(created_at: :desc)
    end
  end
end
