app.controller('HomeController', function ($scope, $http, $mdDialog, Data) {

    $scope.transfer = null;

    $scope.currentData = {
        mode: 'new',
        next_page: 1,
        total: 0,
        data: []
    };

    $scope.$watch(function () {
            return Data.getData();
        }, function (newValue, oldValue) {
            // console.log($scope.transfer, Data.getData());
            if ($scope.transfer != Data.getData()) {
                $scope.transfer = Data.getData();
                $scope.currentData.data.unshift($scope.transfer);
            }
    });

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
            clickOutsideToClose: true
        }).then(function () {

        });
    };

    $scope.init = function () {
        $scope.getUserData();
        $scope.getPosts($scope.currentData)
    };
    $scope.init();

    function PostController($scope, $http, post) {

        $scope.imgIndex = 0;

        $scope.cancel = function () {
            $mdDialog.cancel();
        };

        $scope.fromNow = function (time) {
            return moment(time).fromNow();
        };

        $scope.init = function () {
            $http.get(app.version + 'posts/' + post.id).then(function (response) {
                if (response.data.status == 'success') {

                    $scope.data = response.data.data;

                    $scope.images = function (imagesArr) {
                        //console.log(imagesArr);
                        return imagesArr[$scope.imgIndex].src.url;
                    };
                }
            });
        };


        $scope.next = function (imagesArr) {

            if ($scope.imgIndex < imagesArr.length - 1) {
                $scope.imgIndex++;
            }
            else if ($scope.imgIndex == imagesArr.length - 1) {
                $scope.imgIndex = 0;
            }
            //console.log($scope.imgIndex, imagesArr.length);
        };


        $scope.prev = function (imagesArr) {

            if ($scope.imgIndex > 0) {
                $scope.imgIndex--;
            }
            else if ($scope.imgIndex == 0) {
                $scope.imgIndex = imagesArr.length - 1;
            }
            //console.log($scope.imgIndex, imagesArr.length);
        };

        $scope.init();
    }
});
