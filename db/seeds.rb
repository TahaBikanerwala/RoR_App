# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
User.create!(name: 'Example User', email: 'test@test.co', password: 'password', password_confirmation: 'password', admin: true)
99.times do |n|
  name = Faker::Name.name[0, 20]
  email = Faker::Internet.email
  password = 'password'
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end
