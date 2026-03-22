module Types
  class ActivityMultipleChoiceChoiceType < Types::BaseObject
    implements Types::NodeType

    field :label, String, null: false
    field :correct, Boolean, null: false
    field :position, Integer, null: false
  end
end
