class PersonalizationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_city, only: :show

  # Top items for current user
  def index
    service = PredictionService.new(entity: 'user', entity_id: current_user.id.to_s, num: 5)
    service.call
    #respond_with ActiveModel::ArraySerializer.new(service.fetch_from_db(model: :mongoid), each_serializer: CitySerializer).to_json
    render json: service.fetch_from_db(model: :mongoid)
  end

  # top similar items with current item for current user 
  def show
    service = PredictionService.new(entity: 'item', entity_id: @city.id.to_s, num: 5)
    service.call
    render json: service.fetch_from_db(model: :mongoid)
  end

  private 
  def find_city
    trip = Trip.find params[:id]
    @city = trip.arrival_airport.city
  end
end
