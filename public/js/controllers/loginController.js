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

    function DialogController($scope, $mdDialog, $http, $window) {

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
            });
        };

        $scope.register = function (user) {
            console.log(user);
        };
    }
});