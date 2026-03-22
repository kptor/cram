module Mutations
  module Inputs
    class ActivityPartInput < Types::BaseInputObject
      argument :prompt, String, required: true
      argument :position, Integer, required: false
      argument :choices, [Mutations::Inputs::MultipleChoiceChoiceInput], required: false
    end
  end
end
