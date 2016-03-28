module Services
  module Pio
    class ECommerseEventRequest
      attr_reader :user
      attr_reader :item
      attr_reader :trip

      def initialize user, trip
        @user = user
        @item = trip.arrival_airport.city
        @trip = trip
      end

      def self.event_client
        @event_client ||= PredictionIO::EventClient.new(
          "Dj69yEwTYxp0BdCiZ7IHeCmlsMhSfZBu3uE1xTxI5Xwxt1Mbm8d39VWMotOI0XXU", 
          "http://localhost:7070")

      end

      def pio_event_client
        self.class.event_client
      end

      def create_all_events
        create_user_event
        create_item_event
        create_view_event
        create_purchase_event
      end

      def self.get_events
        events_json = RestClient.get "http://localhost:7070/events.json?accessKey=Dj69yEwTYxp0BdCiZ7IHeCmlsMhSfZBu3uE1xTxI5Xwxt1Mbm8d39VWMotOI0XXU"
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
