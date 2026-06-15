require 'factory_bot'

users = FactoryBot.create_list(:user, 5)

events = FactoryBot.create_list(:event, 10, organizer: users.sample)

events.each do |event|
  FactoryBot.create(:event_user, event: event, user: users.sample)
end
