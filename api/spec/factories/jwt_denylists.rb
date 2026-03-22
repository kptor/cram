FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-03-22 13:28:07" }
  end
end
