# Deterministic Faker output so re-runs produce the same emails
Faker::Config.random = Random.new(42)

# Dev user with known credentials
dev_user = User.find_or_create_by!(email: "test@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
puts "Dev user: #{dev_user.email} (#{dev_user.previously_new_record? ? 'created' : 'already existed'})"

# Additional Faker users
10.times do |i|
  email = Faker::Internet.unique.email
  user = User.find_or_create_by!(email: email) do |u|
    u.password = "password"
    u.password_confirmation = "password"
  end
  puts "User #{i + 1}: #{user.email}"
end

Faker::UniqueGenerator.clear

puts "\nSeeding complete. Total users: #{User.count}"
