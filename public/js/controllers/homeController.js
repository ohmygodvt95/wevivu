app.controller('HomeController', function ($scope, $http, $mdDialog) {

    $scope.currentData = {
        mode: 'new',
        next_page: 1,
        total: 0,
        data: []
    };

    $scope.fromNow = function (time) {
        return moment(time).fromNow();
    }

    $scope.getUserData = function () {
        $http.get(app.version + 'users/' + app.user_id).then(function (response) {
            $scope.user = response.data.data;
        });
    };

    $scope.getPosts = function (data) {
        $http.get(app.version + 'home/' + data.mode + '?page=' + data.next_page).then(function (response) {
            if (response.data.total > 0) {
                data.next_page = response.data.page + 1;
                data.total += response.data.total;
                for (var i = 0; i < response.data.total; i++) {
                    data.data.push(response.data.data[i]);
                }
            }
        });
    };

    $scope.readMore = function () {
        $scope.getPosts($scope.currentData)
    };

    $scope.showPostContent = function (ev, post) {
        $mdDialog.show({
            locals: {post: post},
            controller: PostController,
            templateUrl: '/pages/post_detail.tmpl.html',
            parent: angular.element(document.body),
            targetEvent: ev,
            clickOutsideToClose: false
        }).then(function () {

        });
    };

    $scope.init = function () {
        $scope.getUserData();
        $scope.getPosts($scope.currentData)
    };
    $scope.init();

    function PostController($scope, post) {
        $scope.cancel = function () {
            $mdDialog.cancel();
        };
    }
});
