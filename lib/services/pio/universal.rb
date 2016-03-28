module Services
  module Pio
    class Universal
      def self.create_all_events(user, trip)
        Services::Pio::UniversalEventRequest.new(user, trip).create_all_events
      end
    end
  end
end
