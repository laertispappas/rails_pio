
angular.module('myTravel')
.controller('TypeaheadCtrl', function($scope, $http, cities) {
  /*
  $scope.getLocation = function(val) {
    return $http.get('//maps.googleapis.com/maps/api/geocode/json', {
      params: {
        address: val,
        sensor: false
      }
    }).then(function(response){
      return response.data.results.map(function(item){
        console.log(item);
        return item.formatted_address;
      });
    });
  };
  */
});
