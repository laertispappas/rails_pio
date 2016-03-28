angular.module('myTravel')
.controller('NavCtrl', [
    '$scope',
    'Auth', '$state',
    function($scope, Auth, $state){
      $scope.signedIn = Auth.isAuthenticated;
      $scope.logout = Auth.logout;
      
      Auth.currentUser().then(function (user){
        $scope.user = user;
      });

      $scope.$on('devise:new-registration', function (e, user){
        $scope.user = user;
      });

      $scope.$on('devise:login', function (e, user){
        $scope.user = user;
      });

      $scope.$on('devise:logout', function (e, user){
        $scope.user = {};
        $state.go('welcome')
      });

      $scope.$on('devise:new-session', function(event, currentUser) {
          $state.go('home');
      });

    }]);
