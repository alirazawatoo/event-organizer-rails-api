require 'rails_helper'

RSpec.describe EventUser, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('User').with_foreign_key('user_id').required }
    it { should belong_to(:event).class_name('Event').with_foreign_key('event_id').required }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:event_user)).to be_valid
    end
  end

  describe 'validations' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event) }

    before do
      create(:event_user, user: user, event: event)
    end

    it { should validate_uniqueness_of(:user_id).scoped_to(:event_id).with_message('User can join the same event only once') }
  end
end
