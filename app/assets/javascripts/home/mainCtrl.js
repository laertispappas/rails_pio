angular.module('myTravel')
.controller('MainCtrl', ['$scope', 'trips', 'cities', function($scope, trips, cities){
  $scope.new_trip_data = {};

  $scope.showDeleteTripBtn = true;
  $scope.trips = trips.trips;

  trips.getPersonalizedTrips().then(function(response){
    $scope.personalized_trips = response.data.personalizations;
  }); 

  $scope.getCity = function(val) {
    if (val.length < 3) { return }

    return cities.search(val).then(function(response) {
      return response.data.cities.map(function(city) {
        return city.name + " (" + city.country.two_digit_code + ")";
      });
    });
  };

  $scope.addTrip = function(new_trip_data){
    if(!new_trip_data.departure_city || new_trip_data.arrival_city === '') { return; }
    trips.create({
      trip: {
        departure_city: new_trip_data.departure_city,
        arrival_city: new_trip_data.arrival_city,
        departure_at: new_trip_data.dt.departure_at
      }
    }).success(function(response){
      $scope.new_trip_data = {};
    }).error(function(msg, status, func) {
      alert("Something went wrong. Status: " + status + " ");
    });
  };
  
  $scope.deleteTrip = function(trip) {
    trips.destroy(trip.id).then(function(response) {
      if ($scope.trip == undefined)
        var index = $scope.trips.indexOf(trip);
      $scope.trips.splice(index, 1);
    });
  };

  $scope.today = function() {
    $scope.new_trip_data.dt = new Date();
  };
  $scope.today();

  $scope.clear = function() {
   $scope.new_trip_data.dt = null;
  };

  $scope.inlineOptions = {
    customClass: getDayClass,
    minDate: new Date(),
    showWeeks: true
  };

  $scope.dateOptions = {
    dateDisabled: disabled,
    formatYear: 'yy',
    maxDate: new Date(2020, 5, 22),
    minDate: new Date(),
    startingDay: 1
  };

  function disabled(data) {
    var date = data.date,
        mode = data.mode;
    return mode === 'day' && (date.getDay() === 0 || date.getDay() === 6);
  }

  $scope.toggleMin = function() {
    $scope.inlineOptions.minDate = $scope.inlineOptions.minDate ? null : new Date();
    $scope.dateOptions.minDate = $scope.inlineOptions.minDate;
  };

  $scope.toggleMin();

  $scope.open1 = function() {
    $scope.popup1.opened = true;
  };

  $scope.open2 = function() {
    $scope.popup2.opened = true;
  };

  $scope.setDate = function(year, month, day) {
    $scope.new_trip_data.dt = new Date(year, month, day);
  };

  $scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
  $scope.format = $scope.formats[0];
  $scope.altInputFormats = ['M!/d!/yyyy'];

  $scope.popup1 = {
    opened: false
  };

  $scope.popup2 = {
    opened: false
  };

  var tomorrow = new Date();
  tomorrow.setDate(tomorrow.getDate() + 1);
  var afterTomorrow = new Date();
  afterTomorrow.setDate(tomorrow.getDate() + 1);
  $scope.events = [
  {
    date: tomorrow,
      status: 'full'
  },
  {
    date: afterTomorrow,
    status: 'partially'
  }
  ];

  function getDayClass(data) {
    var date = data.date,
        mode = data.mode;
    if (mode === 'day') {
      var dayToCheck = new Date(date).setHours(0,0,0,0);

      for (var i = 0; i < $scope.events.length; i++) {
        var currentDay = new Date($scope.events[i].date).setHours(0,0,0,0);

        if (dayToCheck === currentDay) {
          return $scope.events[i].status;
        }
      }
    }

    return '';
  }

}]);
