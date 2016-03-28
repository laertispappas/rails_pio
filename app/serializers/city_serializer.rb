class CitySerializer < ActiveModel::Serializer
  attributes :name
  has_one :country
end
