module Services
  module Pio
    class ECommerseEventRequest
      include Services::Pio::Client

      attr_reader :user
      attr_reader :item
      attr_reader :trip

      def initialize user, trip
        @user = user
        @item = trip.arrival_airport.city
        @trip = trip
      end

      def create_all_events
        create_user_event
        create_item_event
        create_view_event
        create_purchase_event
      end

      def self.get_events
        events_json = RestClient.get "#{Rails.configuration.x.predictionio["host"]}/events.json?accessKey=#{Rails.configuration.x.predictionio["event_client"]["access_key"]}"
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
          item.id,
          'properties' => {
            'itemCity' => item.name,
            'itemCountry' => item.country.two_digit_code
          }
        )
      end

      def create_view_event
        pio_event_client.create_event('view', 
                                      'user', 
                                      user.id, 
                                      'targetEntityType' => 'item', 
                                      'targetEntityId' => item.id)
      end

      def create_purchase_event
        pio_event_client.create_event('buy', 
                                      'user', 
                                      user.id, 
                                      'targetEntityType' => 'item', 
                                      'targetEntityId' => item.id)
      end
    end
  end
end
