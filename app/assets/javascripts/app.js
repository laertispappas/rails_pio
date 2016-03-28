angular.module('myTravel', ['ui.router', 'templates', 'Devise', 'ui.bootstrap'])
    .config([
    '$stateProvider',
    '$urlRouterProvider',
    function($stateProvider, $urlRouterProvider) {
        $stateProvider
            .state('welcome', {
              url: '/welcome',
              templateUrl: 'welcome/_welcome.html',
              controller: 'WelcomeCtrl'
            })
            .state('home', {
                url: '/home',
                templateUrl: 'home/_home.html',
                controller: 'MainCtrl',
                resolve: {
                  postPromise: ['trips', function(trips){
                  return trips.getAll();
                }]
              },
            })
            .state('login', {
              url: '/login',
              templateUrl: 'auth/_login.html',
              controller: 'AuthCtrl',
              onEnter: ['$state', 'Auth', function($state, Auth) {
                Auth.currentUser().then(function (){
                  $state.go('home');
                })
              }]
            })
            .state('register', {
              url: '/register',
              templateUrl: 'auth/_register.html',
              controller: 'AuthCtrl',
              onEnter: ['$state', 'Auth', function($state, Auth) {
                Auth.currentUser().then(function (){
                  $state.go('home');
                })
              }]
            })
            .state('trips', {
                url: '/trips/{id}',
                templateUrl: 'trips/trip.html',
                controller: 'TripsCtrl',
                resolve: {
                    trip: ['$stateParams', 'trips', function($stateParams, trips) {
                        return trips.get($stateParams.id);
                    }]
                }
            });

        $urlRouterProvider.otherwise('welcome');
    }]);
