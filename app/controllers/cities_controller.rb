class CitiesController < ApplicationController
  def index
    if params[:q].present?
      cities = City.search(params[:q])
    else
      cities = City.all.take(100)
    end
    render json: cities
    #respond_with ActiveModel::ArraySerializer.new(cities, each_serializer: CitySerializer).to_json
  end
end
