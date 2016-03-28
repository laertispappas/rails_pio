class AirportSerializer < ActiveModel::Serializer
  attributes :name
  has_one :city
end
