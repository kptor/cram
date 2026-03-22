module Types
  class ActivityMultipleChoiceType < Types::BaseObject
    implements Types::NodeType

    field :prompt, String, null: false
    field :choices, [Types::ActivityMultipleChoiceChoiceType], null: false

    def choices
      dataloader.with(Sources::AssociationLoader, Activity::MultipleChoice, :choices).load(object)
    end
  end
end
