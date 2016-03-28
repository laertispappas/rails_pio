class PredictionService
  include Services::Pio::Client
  class << self
    def engine_client
      @client ||= PredictionIO::EngineClient.new("http://localhost:8000")
    end
  end
  
  attr_reader :opts
  attr_reader :entity_ids

  def initialize(params = {})
    @opts = params
  end

  def call
    result = client.send_query(opts[:entity].to_s => opts[:entity_id] , "num" => opts[:num])
    @entity_ids = result["itemScores"].map{ |item| item["item"] }
    self
  end

  def query
    raise NotImplementedError
  end

  def fetch_from_db(model: :active_record)
    case model
    when :active_record
      City.where(id: entity_ids)
    when :mongoid
      City.find entity_ids
    else
      raise "Unknown model #{model}"
    end
  end

  private

  def client
    @client ||= self.class.client
  end
end
