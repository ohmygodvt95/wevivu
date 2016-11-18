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

    function DialogController($scope, $mdDialog) {

        $scope.hide = function () {
            $mdDialog.hide();
        };

        $scope.cancel = function () {
            $mdDialog.cancel();
        };

        $scope.login = function (user) {
            console.log(user);
        };

        $scope.register = function (user) {
            console.log(user);
        };
    }
});