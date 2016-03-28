class FormTrip
  class << self
    # Parameters: {{"departure_city"=>"Athens (GR)", "arrival_city"=>"London (GB)"}}
    def create(params, user)
      departure_city = params[:departure_city].gsub(/\(\w+\)/, '').squish
      arrival_city = params[:arrival_city].gsub(/\(\w+\)/, '').squish
      Trip.create!(user: user, 
                   departure_airport: City.find_by!(name: departure_city).airports.first, 
                   arrival_airport: City.find_by!(name: arrival_city).airports.first)
      
    end
  end
end
