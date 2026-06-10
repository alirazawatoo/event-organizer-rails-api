class EventUser < ApplicationRecord 
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', optional: false
  belongs_to :event, class_name: 'Event', foreign_key: 'event_id', optional: false

  validates :user_id, uniqueness: { scope: :event_id, message: 'User can join the same event only once' }
end
