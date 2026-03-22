FactoryBot.define do
  factory :activity_multiple_choice_choice, class: "Activity::MultipleChoice::Choice" do
    association :multiple_choice, factory: :activity_multiple_choice
    label { Faker::Lorem.sentence }
    correct { false }
    sequence(:position) { |n| n }
  end
end
