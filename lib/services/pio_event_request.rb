module Services
  class PioUniversalEventRequest

    attr_reader :user
    attr_reader :item
    attr_reader :trip

    def initialize user, trip
      @user = user
      @item = trip.arrival_airport.city
      @trip = trip
    end

    def pio_event_client
      PredictionIO::EventClient.new(
        "gicSs4EyAcMrEieMXLyfbsd3ZDJrxlGPKlFbH9JEtFbgDanKYHedGDH4XeXPZJtt", 
        "http://localhost:7070")
    end


    def create_all_events
      create_user_event
      create_item_event
      create_purchase_event
    end

    def self.get_events
      events_json = RestClient.get "http://localhost:7070/events.json?accessKey=gicSs4EyAcMrEieMXLyfbsd3ZDJrxlGPKlFbH9JEtFbgDanKYHedGDH4XeXPZJtt"
      events_hash = ActiveSupport::JSON.decode(events_json)
      events_hash
    end

    def create_user_event
      pio_event_client.create_event(
        "$set", 
        "user", 
        user.id)
    end

    def create_item_event
      pio_event_client.create_event(
        "$set",
        "item",
        item.id)
    end

    def create_purchase_event
      pio_event_client.create_event('purchase', 
                          'user', 
                          user.id, 
                          'targetEntityType' => 'item', 
                          'targetEntityId' => item.id)
    end


    def create_user_event2
      pio_event_client.create_event(
        "$set", 
        "user", 
        user.id, 
        'properties' => {
          'gender' => user.gender,
          'userCountry' => user.country.two_digit_code,
          'userBrand' => user.brand.name,
          'customerType' => user.customer_type
        })
    end

    def create_item_event2
      pio_event_client.create_event(
        "$set",
        "item",
        item.id,
        'properties' => {
          'itemCity' => item.name,
          'itemCountry' => item.country.two_digit_code
        }
      )
    end

    def create_purchase_event2
      pio_event_client.create_event('purchase', 
                          'user', 
                          user.id, 
                          'targetEntityType' => 'item', 
                          'targetEntityId' => item.id,
                          'eventTime' => trip.reserved_at,
                          'properties' => {
                            'departureCityName' => trip.departure_airport.city.name,
                            'departureAt' => trip.departure_at,
                            'seatClass' => trip.seat_class
                          })

    end
  end
end
