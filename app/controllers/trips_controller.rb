class TripsController < ApplicationController
  before_action :authenticate_user!

  def index
    trips = current_user.trips
    respond_with ActiveModel::ArraySerializer.new(trips, each_serializer: TripSerializer).to_json
    #render json: polls, serializer: ActiveModel::ArraySerializer, each_serializer: PollSerializer, meta: meta_attributes(polls) 
  end

  def create
    trip = FormTrip.create(params[:trip], current_user)
    respond_with trip
  end

  def show
    trip = Trip.find params[:id]
  
    # TODO: Add authorization
    redirect_to root_path unless trip.user == current_user
    respond_with trip
  end

  def destroy
    trip = Trip.find params[:id]
    # TODO: Add authorization
    redirect_to root_path unless trip.user == current_user
    trip.destroy
    head :ok
  end
end
