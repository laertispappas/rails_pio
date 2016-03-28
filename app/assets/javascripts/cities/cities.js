angular.module('myTravel')
    .factory('cities', ['$http', function($http){
        var o = {
            cities: []
        };

        o.search = function(val){
          return $http.get('/cities.json?q=' + val).success(function(data) {
            angular.copy(data.cities, o.cities);
          }).error(function(err) {
            console.log(err);
          });
        };
        o.getAll = function() {
            return $http.get('/cities.json').success(function(data){
              angular.copy(data, o.cities);
            });
        };

        o.get = function(id) {
            return $http.get('/cities/' + id + '.json').then(function(res){
                return res.data;
            });
        };

        o.create = function(city) {
            return $http.post('/cities.json', city).success(function(data){
                o.cities.push(data);
            });
        };

        return o;
    }]);
