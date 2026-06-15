# spec/models/event_spec.rb

require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:date) }
    it { should validate_presence_of(:location) }
    it { should validate_presence_of(:organizer) }
  end

  describe 'associations' do
    it { should belong_to(:organizer).class_name('User').with_foreign_key('organizer_id') }
    it { should have_many(:event_users).class_name('EventUser').dependent(:destroy) }
    it { should have_many(:users).class_name('User').through(:event_users) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:event)).to be_valid
    end

    it 'creates an event with users' do
      event = FactoryBot.create(:event_with_users, users_count: 3)
      expect(event.users.count).to eq(3)
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }

    describe 'organized_by_user' do
      it 'returns events organized by the specified user' do
        event = create(:event, organizer: user)
        
        result = Event.organized_by_user(user)

        expect(result).to include(event)
      end

      it 'does not return events organized by other users' do
        other_user = create(:user)
        event = create(:event, organizer: other_user)

        result = Event.organized_by_user(user)

        expect(result).not_to include(event)
      end
    end

    describe 'not_joined_by_user' do
      it 'returns events not joined by the specified user' do
        event = create(:event)
        create(:event_user, event: event, user: user)

        result = Event.not_joined_by_user(user).upcoming_events

        expect(result).not_to include(event)
      end

      it 'returns events not joined by any user' do
        event = create(:event)

        result = Event.not_joined_by_user(user).upcoming_events

        expect(result).to include(event)
      end

      it 'does not return events joined by the specified user' do
        event = create(:event, organizer: user)

        result = Event.not_joined_by_user(user).upcoming_events

        expect(result).not_to include(event)
      end
    end

    describe '.upcoming_events' do
      let!(:past_event) { create(:event, date: 1.day.ago) }
      let!(:upcoming_event1) { create(:event, date: 1.day.from_now) }
      let!(:upcoming_event2) { create(:event, date: 3.days.from_now) }
  
      it 'returns only upcoming events' do
        upcoming_events = Event.upcoming_events
  
        expect(upcoming_events).to include(upcoming_event1, upcoming_event2)
        expect(upcoming_events).not_to include(past_event)
      end
  
      it 'returns events ordered by date in ascending order' do
        upcoming_events = Event.upcoming_events
  
        expect(upcoming_events).to eq([upcoming_event1, upcoming_event2])
      end
    end
  end
end
