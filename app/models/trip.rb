class Trip
  include Mongoid::Document
  include AgnosticBackend::Indexable 

  field :seat_class, type: String
  field :reserved_at, type: DateTime
  field :departure_at, type: DateTime

  belongs_to :user
  belongs_to :departure_airport, class_name: 'Airport', inverse_of: :airports
  belongs_to :arrival_airport, class_name: 'Airport', inverse_of: :airports

  define_index_fields do
    string :id, value: proc { id.to_s }
    string :seat_class, label: 'seat_class'
    date :reserved_at
    string :arrival_country, value: proc { arrival_country.two_digit_code }
    string :arrival_city, value: proc { arrival_city.name }
    string :departure_country, value: proc { departure_country.two_digit_code }
    string :departure_city, value: proc { departure_city.name }

    struct :user, from: User
  end

  define_index_notifier { self }

  def arrival_country
    arrival_airport.city.country
  end

  def arrival_city
    arrival_airport.city
  end

  def departure_country
    departure_airport.city.country
  end
  def departure_city
    departure_airport.city
  end
end
