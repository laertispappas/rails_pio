angular.module('myTravel')
    .factory('trips', ['$http', function($http){
        var o = {
            trips: [],
            personalized_trips: []
        };

        o.getPersonalizedTrips = function() {
          return $http.get('/personalizations.json').success(function(data) {
            angular.copy(data.personalizations, o.personalized_trips)
          });
        };

        o.getSimilarLocationsFor = function(tripID) {
          return $http.get('personalizations/' + tripID + '.json').success(function(data) {
            angular.copy(data.personalizations, o.personalized_trips)
          }).error(function(err) {
            alert("Could not get recommendations");
          });
        };

        o.getAll = function() {
            return $http.get('/trips.json').success(function(data){
               angular.copy(data, o.trips);
            });
        };

        o.get = function(id) {
            return $http.get('/trips/' + id + '.json').then(function(res){
                return res.data.trip;
            });
        };

        o.create = function(trip) {
            return $http.post('/trips.json', trip).success(function(data){
              console.log(data);
                o.trips.push(data.trip);
            });
        };

        o.destroy = function(tripID) {
          return $http.delete('/trips/' + tripID + '.json').success(function(data) {
            return data;
          });
        };
        return o;
    }]);

