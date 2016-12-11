app.controller('ProfileController', function ($scope, $http, $location, $routeParams, $mdDialog, Data, ngToast) {
    $scope.user_id = $routeParams.user_id;
    $scope.transfer = null;
    $scope.busy = false;
    /* function*/
    $scope.fromNow = function (time) {
        return moment(time).fromNow();
    };
    $scope.isOwn = function (user_id) {
        return user_id == app.user_id;
    };

    /*user*/
    $scope.updatePassword = function (b, c) {
        $http.patch(app.version + 'password/' + $scope.user_id, {user: {password: b, password_confirmation: c}}).then(function (response) {
            // console.log($scope.user_id);
            ngToast.create("Change successful");
        }, function (response) {
            ngToast.create("Password something wrong! Please check again!");
        });
    };
    $scope.update = function () {
        $http.patch(app.version + 'users/' + $scope.user_id, {user: $scope.user}).then(function (response) {
            // console.log($scope.user_id);
            $scope.user = response.data.data;
            ngToast.create("Update profile successful");
        }, function (response) {
            ngToast.create("Update profile failure");
        });
    };
    $scope.getUserData = function () {
        if(app.user_id != $scope.user_id) $location.path('/error');
        $http.get(app.version + 'users/' + $scope.user_id).then(function (response) {
            // console.log($scope.user_id);
            $scope.user = response.data.data;
        }, function (response) {

            $location.path('/error');
        });

    };



    $scope.init = function () {
        $scope.getUserData();
    };
    $scope.init();
});