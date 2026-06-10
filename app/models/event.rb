class Event < ApplicationRecord 
  belongs_to :organizer, class_name: 'User', foreign_key: 'organizer_id'
  has_many :event_users, class_name: 'EventUser', dependent: :destroy
  has_many :users, class_name: 'User', through: :event_users

  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true, length: { maximum: 300 }
  validates :date, presence: true
  validates :location, presence: true
  validates :organizer, presence: true

  scope :upcoming_events, -> { where('date >= ?', Time.now).order(date: :asc) }

  scope :organized_by_user, ->(user) do
    where(organizer_id: user.id)
  end

  scope :not_joined_by_user, ->(user) do
    where.not(id: user.events.ids | Event.organized_by_user(user).ids)
  end
end
