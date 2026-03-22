FactoryBot.define do
  factory :activity do
    title { Faker::Educator.course_name }
    description { Faker::Lorem.paragraph }
    user
  end
end
