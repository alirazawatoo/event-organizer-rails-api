# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'attributes' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:id).of_type(:integer) }

    it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:jti).of_type(:string) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:events) }
    it { is_expected.to have_many(:events).through(:event_users) }
    it { is_expected.to have_many(:event_users) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_length_of(:name).is_at_most(15) }
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(FactoryBot.create(:user)).to be_valid
    end
  end
end
