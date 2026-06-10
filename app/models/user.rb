class User < ApplicationRecord
  has_many :events, foreign_key: :organizer_id, dependent: :destroy
  has_many :event_users, class_name: 'EventUser'
  has_many :events, class_name: 'Event', through: :event_users

  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :jwt_authenticatable,
         jwt_revocation_strategy: self    
 
  validates :name, presence: true, length: { maximum: 15 }
end
