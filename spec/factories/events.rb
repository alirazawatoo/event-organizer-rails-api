FactoryBot.define do
  factory :event do
    sequence(:name) do |n|
      event_type = ['Conference', 'Seminar', 'Workshop'].sample
      title = Faker::Book.title
      truncated_title = title[0..(30 - event_type.length - 2)]
      "#{truncated_title} #{event_type}"
    end
    description { Faker::Lorem.paragraph }
    date { Faker::Time.forward(days: 30, period: :all) }
    location { Faker::Address.city }
    association :organizer, factory: :user

    factory :event_with_users do
      transient do
        users_count { 5 }
      end

      after(:create) do |event, evaluator|
        users = create_list(:user, evaluator.users_count)
        users.each do |user|
          create(:event_user, user: user, event: event)
        end
      end
    end
  end
end
