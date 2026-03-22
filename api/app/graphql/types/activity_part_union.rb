module Types
  class ActivityPartUnion < Types::BaseUnion
    possible_types Types::ActivityMultipleChoiceType

    def self.resolve_type(object, _context)
      case object
      when Activity::MultipleChoice
        Types::ActivityMultipleChoiceType
      else
        raise GraphQL::RequiredImplementationMissingError,
              "Unknown partable type: #{object.class}"
      end
    end
  end
end
