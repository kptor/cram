module Types
  class UserType < Types::BaseObject
    implements Types::NodeType

    field :email, String, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
  end
end
