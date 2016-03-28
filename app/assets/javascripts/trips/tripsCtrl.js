angular.module('myTravel')
.controller('TripsCtrl', ['$scope', 'trips', 'trip', function($scope, trips, trip){
  $scope.trip = trip;

  trips.getSimilarLocationsFor(trip.id).then(function(response) {
    $scope.personalized_trips =  response.data.personalizations;
  });

}]);
