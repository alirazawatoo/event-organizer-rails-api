# frozen_string_literal: true

class EventSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :description, :date, :location, :organizer_id

  has_many :users
end
