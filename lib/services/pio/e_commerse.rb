module Services
  module Pio
    class ECommerse
      def self.create_all_events(user, trip)
        Services::Pio::ECommerseEventRequest.new(user, trip).create_all_events
      end
    end
  end
end
