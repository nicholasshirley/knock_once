FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@test.com"}
    sequence(:password) { |n| "password#{n}" }
    sequence(:password_confirmation) { |n| "password#{n}" }
  end
end
