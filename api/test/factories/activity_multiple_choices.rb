FactoryBot.define do
  factory :activity_multiple_choice, class: "Activity::MultipleChoice" do
    prompt { Faker::Lorem.question }
  end
end
