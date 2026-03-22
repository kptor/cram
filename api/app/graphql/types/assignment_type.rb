module Types
  class AssignmentType < Types::BaseObject
    implements Types::NodeType

    field :activity, Types::ActivityType, null: false
    field :user, Types::UserType, null: false
    field :status, Types::AssignmentStatusEnum, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def activity
      dataloader.with(Sources::RecordById, Activity).load(object.activity_id)
    end

    def user
      dataloader.with(Sources::RecordById, User).load(object.user_id)
    end
  end
end
