class Airport
  include Mongoid::Document
  field :code, type: String
  field :name, type: String
  
  belongs_to :city
  has_many :trips, class_name: 'Trip', inverse_of: :departure_airport
  has_many :trips, class_name: 'Trip', inverse_of: :arrival_airport
  #embedded_in :trip
  #embedded_in :trip
  #embedded_in :city
end
