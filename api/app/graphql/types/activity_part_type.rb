module Types
  class ActivityPartType < Types::BaseObject
    implements Types::NodeType

    field :position, Integer, null: false
    field :partable, Types::ActivityPartUnion, null: false

    def partable
      dataloader.with(Sources::PolymorphicLoader, :partable).load(object)
    end
  end
end
