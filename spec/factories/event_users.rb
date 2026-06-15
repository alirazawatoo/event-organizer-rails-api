FactoryBot.define do
  factory :event_user do
    association :user, factory: :user
    association :event, factory: :event 
  end
end
