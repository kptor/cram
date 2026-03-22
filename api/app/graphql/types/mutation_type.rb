# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :activity_create, mutation: Mutations::ActivityCreate
    field :assignment_create, mutation: Mutations::AssignmentCreate
    field :assignment_update, mutation: Mutations::AssignmentUpdate
  end
end
