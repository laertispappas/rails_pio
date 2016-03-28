require 'csv'

namespace :import_csv do
  desc "Destroy all data"
  task :destroy_all => :environment do
    Country.destroy_all
    Brand.destroy_all
  end

  desc "Import user data and item data"
  task :all, [:file_path] => :environment do |t, args|
    file = args[:file_path] || "aa"
    unless File.exists?(file)
      file = "../../dataset/private/persons_trips.csv"
    end
    

    current_user = nil
    begin 
      CSV.foreach(file, headers: true) do |csv|
        user_id = csv["UserID"]
        user_email = csv["UserEmail"].present? ? csv["UserEmail"] : "user#{user_id}@example.com"
        user_email = user_email.downcase
        gender = csv["Gender"]
        brand = Brand.find_or_create_by!(name: csv["Brand"])
        user_country_code = csv["PersonCountry"]

        departure_airport_id = csv["DepartureAirportID"]
        departure_airport_code = csv["DepartureAirportCode"].present? ? csv["DepartureAirportCode"] : nil
        departure_airport_name = csv["DepartureAirportName"].present? ? csv["DepartureAirportName"] : nil
        departure_airport_city_name = csv["DepartureAirportCity"].present? ? csv["DepartureAirportCity"] : nil
        departure_airport_country_code = csv["DepartureAirportCountry"].present? ? csv["DepartureAirportCountry"] : nil

        arrival_airport_id = csv["ArrivalAirportID"]
        arrival_airport_code = csv["ArrivalAirportCode"].present? ? csv["ArrivalAirportCode"] : nil
        arrival_airport_name = csv["ArrivalAirportName"].present? ? csv["ArrivalAirportName"] : nil
        arrival_airport_city_name = csv["ArrivalAirportCity"].present? ? csv["ArrivalAirportCity"] : nil
        arrival_airport_country_code = csv["ArrivalAirportCountry"].present? ? csv["ArrivalAirportCountry"] : nil

        seat_class = csv["Seatclass"]
        customer_type = csv["CustomerType"]
        reserved_at = csv["reserved_at"]
        departure_at = csv["DepartureAt"]

        user_country = Country.find_or_create_by!(two_digit_code: user_country_code)
        arrival_country = Country.find_or_create_by!(two_digit_code: arrival_airport_country_code)
        departure_country = Country.find_or_create_by!(two_digit_code: departure_airport_country_code)
        arrival_city = City.find_or_create_by!(name: arrival_airport_city_name, country: arrival_country)
        departure_city = City.find_or_create_by!(name: departure_airport_city_name, country: departure_country)
        arrival_airport = Airport.find_or_create_by!(code: arrival_airport_code, name: arrival_airport_name, city: arrival_city)
        departure_airport = Airport.find_or_create_by!(code: departure_airport_code, name: departure_airport_name, city: departure_city)
  
        user = User.find_or_initialize_by(email: user_email)
        current_user = user
        current_user.email = user_email
        user.update_attributes!(brand: brand, 
                                country: user_country, 
                                gender: gender, 
                                customer_type: customer_type,
                                password: "pappaspappas", 
                                password_confirmation: "pappaspappas")
        Trip.create!(seat_class: seat_class, 
                     reserved_at: reserved_at, 
                     departure_at: departure_at, 
                     user: user, 
                     departure_airport: departure_airport, 
                     arrival_airport: arrival_airport)

      end
    rescue Exception => e
      puts "Could not create user with email: #{current_user.email}"
      raise e
    end
  end
end
