require 'rest_client'
class PioImporter
  def initialize(template: :universal)
    case template
    when :universal
      @context = Services::Pio::Universal
    when :e_commerse
      @context = Services::Pio::ECommerse
    else
      raise "Unknown template #{template.to_s}"
    end
  end

  def to_pio
    User.each do |user|
      user.trips.each do |trip|
        @context.create_all_events(user, trip)
      end
    end
  end

  class << self
    def delete_app_data(app_name)
      system "pio app data-delete #{app_name}"
    end
  end
end
