module Mutations
  module Inputs
    class MultipleChoiceChoiceInput < Types::BaseInputObject
      argument :label, String, required: true
      argument :correct, Boolean, required: false
      argument :position, Integer, required: false
    end
  end
end
