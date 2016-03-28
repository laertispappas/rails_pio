module Services
  module Pio
    module Client
      def self.included(target)
        target.include(InstanceMethods)
        target.extend(ClassMethods)
      end

      module InstanceMethods
        def pio_event_client
          @pio_event_client ||= self.class.pio_event_client
        end

        def pio_engine_client
          @pio_engine_client ||= self.class.pio_engine_client
        end
      end

      module ClassMethods
        def pio_engine_client
          @pio_engine_client ||= PredictionIO::EngineClient.new(Rails.configuration.x.predictionio["engine_client"]["host"])
        end

        def pio_event_client
          @pio_event_client ||= PredictionIO::EventClient.new(
            Rails.configuration.x.predictionio["event_client"]["access_key"],
            Rails.configuration.x.predictionio["event_client"]["host"])
        end
      end

    end
  end
end
