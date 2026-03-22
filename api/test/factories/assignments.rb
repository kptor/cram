FactoryBot.define do
  factory :assignment do
    activity
    user
    status { :not_started }
  end
end
