var app = angular.module("wevivu", ['ngMaterial']);
app.version = '/api/v1/'

app.controller('LoginController', function ($scope, $mdDialog) {

    $scope.showLoginAndSignupForm = function (ev) {

        $mdDialog.show({
            controller: DialogController,
            templateUrl: '/pages/login_register.tmpl.html',
            parent: angular.element(document.body),
            targetEvent: ev,
            clickOutsideToClose: false
        }).then(function () {

        });
    };

    function DialogController($scope, $mdDialog, $http, $window, $timeout) {

        $scope.hide = function () {
            $mdDialog.hide();
        };

        $scope.cancel = function () {
            $mdDialog.cancel();
        };

        $scope.login = function (user) {
            $http.post(app.version + 'session', user).then(function(response){
                if(response.data.status == 'success'){
                    $window.location.reload();
                }
                else {
                    $scope.loginError.show = true;
                    $scope.loginError.data = response.data.data.error;
                }
            });
        };

        $scope.register = function (user) {
            $scope.registerError = false;
            $http.post(app.version + 'users', user).then(function (response) {
                if (response.data.status == 'success') {
                    $scope.registerSuccess = true;
                    $timeout(function () {
                        $scope.registerSuccess = false;
                    }, 5000);
                }
            }, function () {
                $scope.registerError= true;
            });
        };
    }
});