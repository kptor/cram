module Types
  class ActivityType < Types::BaseObject
    implements Types::NodeType

    field :title, String, null: false
    field :description, String
    field :creator, Types::UserType, null: false
    field :parts, [Types::ActivityPartType], null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false

    def creator
      dataloader.with(Sources::RecordById, User).load(object.user_id)
    end

    def parts
      dataloader.with(Sources::AssociationLoader, Activity, :parts).load(object)
    end
  end
end
