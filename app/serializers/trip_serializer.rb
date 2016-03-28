class TripSerializer < ActiveModel::Serializer
  attributes :id, :link

  has_one :arrival_airport
  has_one :departure_airport

  def link
    trip_path(id)
  end
end
