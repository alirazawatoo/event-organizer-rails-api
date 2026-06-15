# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    encrypted_password { Devise.friendly_token }
    password { Faker::Internet.password(min_length: 8) }
    reset_password_token { nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
    name { Faker::Name.name.slice(0, 15) }
    jti { Faker::Alphanumeric.alphanumeric(number: 10) }
    
    factory :user_with_reset_password do
      reset_password_token { Faker::Internet.password }
      reset_password_sent_at { Time.current }
    end
  end
end
