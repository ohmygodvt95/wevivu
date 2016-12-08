app.controller('WallController', function ($scope, $http, $mdDialog, Data, ngToast, Upload) {
    $scope.transfer = null;
    $scope.busy = false;
    $scope.currentData = {
        query: '',
        mode: 'me',
        after: 0,
        before: 0,
        total: 0,
        limit: 20,
        data: []
    };
    /* function*/
    $scope.fromNow = function (time) {
        return moment(time).fromNow();
    };
    $scope.isOwn = function (user_id) {
        return user_id == app.user_id;
    };

    function isContrain(e, arr){
        for(var i = 0; i < arr.length; i++){
            if (e.id == arr[i].id) return true;
        }
        return false;
    }

    $scope.cover = function(file){

    };
    $scope.avatar = function(file){

    };
    $scope.$watch('cover', function (files) {
        // console.log(typeof files);
        if (typeof files != 'function') {
            console.log(files);
            if(files){
                $scope.doing = true;
                Upload.upload({
                    url: app.version + 'cover',
                    method: 'POST',
                    data: {file: files}
                }).then(function (response) {
                    if(response.data.status == 'success'){
                        // console.log(response.data);
                        $scope.user = response.data.data;
                    }
                });
            }
        }
    });

    $scope.$watch('avatar', function (file) {
        console.log(typeof file);
        if (typeof file != 'function') {
            console.log(file);
            if(file){
                $scope.doing = true;
                Upload.upload({
                    url: app.version + 'avatar',
                    method: 'POST',
                    data: {file: file}
                }).then(function (response) {
                    if(response.data.status == 'success'){
                        // console.log(response.data);
                        $scope.user = response.data.data;
                    }
                });
            }
        }
    });

    $scope.$watch(function () {
        return Data.getData();
    }, function (newValue, oldValue) {
        // console.log($scope.transfer, Data.getData());
        if ($scope.transfer != Data.getData()) {
            $scope.transfer = Data.getData();
            $scope.currentData.data.unshift($scope.transfer);
        }
    });
    /*user*/
    $scope.getUserData = function () {
        $http.get(app.version + 'users/' + app.user_id).then(function (response) {
            $scope.user = response.data.data;
            $(document).ready(function(){
                $("#sticker").sticky({topSpacing: 90});
            });
        });

    };
    /*change mode*/
    $scope.changeMode = function (mode) {
        $scope.currentData.mode = mode;
        $scope.currentData.after = 0;
        $scope.currentData.before = 0;
        $scope.currentData.total = 0;
        $scope.currentData.data.length = 0;
        $scope.getPosts($scope.currentData);

    };
    /*bookmark*/
    $scope.createBookmark = function (post) {
        $http.post(app.version + 'bookmarks', {bookmark: {user_id: app.user_id, post_id: post.id}}).then(function (response) {
            ngToast.create(response.data.data);
            console.log(response.data);
        });
    };

    /*Post get*/
    $scope.deletePost = function (post) {
        $http.delete(app.version + 'posts/' + post.id).then(function (response) {
            //console.log(response.data);
            $scope.currentData.data.forEach(function (value, index) {
                if (value.id == response.data.data.id){
                    $scope.currentData.data.splice(index, 1);
                    return 0;
                }
            });
        });
    };
    $scope.getPosts = function (data) {
        $scope.busy = true;
        $http.get(app.version + 'home/' + data.mode + '?after=' + data.after + "&limit=" + data.limit + "&query=" + data.query)
            .then(function (response) {
                if (response.data.total > 0) {
                    data.after = response.data.after;
                    data.before = response.data.before == 0 ? data.before : response.data.before;
                    for(var i = 0; i < response.data.data.length; i++){
                        if(!isContrain(response.data.data[i], data.data))
                            data.data.push(response.data.data[i]);
                    }
                    $scope.busy = false;
                    // console.log(data.data, response.data.data);
                }
            }, function () {
                $scope.busy = false;
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
    /*int */
    $scope.init = function () {
        $scope.getUserData();
    };
    $scope.init();


    function PostController($scope, $http, post) {
        function isContrain(e, arr){
            for(var i = 0; i < arr.length; i++){
                if (e.id == arr[i].id) return true;
            }
            return false;
        }

        /*customize function*/
        $scope.cancel = function () {
            $mdDialog.cancel();
        };
        $scope.isOwn = function (user_id) {
            return user_id == app.user_id;
        };

        $scope.fromNow = function (time) {
            return moment(time).fromNow();
        };

        /*Rate */
        function updateRate(p, rate, rates){
            p.rate = rate;
            p.post.data.rates = rates
        }

        $scope.rate = function (p, point) {
            if(!p.rate){
                $http.post(app.version + 'rates', {rate: {user_id: app.user_id, post_id: p.post.id, point: point}})
                    .then(function (response) {
                        updateRate(p, response.data.data.rate, response.data.data.rates);
                    });
            }
            else if(p.rate.point != point){
                $http.patch(app.version + 'rates', {rate: {user_id: app.user_id, post_id: p.post.id, point: point}})
                    .then(function (response) {
                        updateRate(p, response.data.data.rate, response.data.data.rates);
                    });
            }
            else{

                $http.delete(app.version + 'rates/' + p.rate.id)
                    .then(function (response) {
                        updateRate(p, null, response.data.data.rates);
                    });
            }
        };

        /* comment*/
        $scope.dataComments = {
            total: 0,
            after: 0,
            before: 0,
            limit: 15,
            data: []
        };
        $scope.deleteComment = function (comment) {
            $http.delete(app.version + 'comments/' + comment.id).then(function (response) {
                $scope.dataComments.data.forEach(function (v, i) {
                    if(v.id == response.data.data.id){
                        $scope.dataComments.data.splice(i, 1);
                        $scope.dataComments.total--;
                        $scope.data.post.data.comments = response.data.data.comments;
                        return 0;
                    }
                });
            });
        };
        $scope.createComment = function (body) {
            if ($scope.comment.length > 0)
                $http.post(app.version + 'comments', {comment: {user_id: app.user_id, post_id: $scope.data.post.id, body: body}})
                    .then(function (response) {
                        if(response.data.status == 'success'){
                            if(!isContrain(response.data.data.comment, $scope.dataComments.data)){
                                $scope.dataComments.data.push(response.data.data.comment);
                                $scope.data.post.data.comments = response.data.data.comments;
                                $scope.comment = '';
                                $scope.dataComments.total++;
                            }
                        }
                    });
        };

        $scope.getComments = function(data){
            $scope.busy = true;
            $http.get(app.version + 'comments?post_id=' + $scope.data.post.id +"&after=" + data.after + "&limit=" + data.limit)
                .then(function (response) {
                    if (response.data.total > 0) {
                        data.after = response.data.after;
                        data.before = response.data.before == 0 ? data.before : response.data.before;
                        for(var i = 0; i < response.data.data.length; i++){
                            if(!isContrain(response.data.data[i], data.data)){
                                data.data.push(response.data.data[i]);
                                data.total++;
                            }
                        }
                        $scope.busy = false;
                        // console.log(data.data, response.data.data);
                    }
                });
        };
        /*image button*/
        $scope.imgIndex = 0;

        $scope.next = function (imagesArr) {

            if ($scope.imgIndex < imagesArr.length - 1) {
                $scope.imgIndex++;
            }
            else if ($scope.imgIndex == imagesArr.length - 1) {
                $scope.imgIndex = 0;
            }
        };


        $scope.prev = function (imagesArr) {

            if ($scope.imgIndex > 0) {
                $scope.imgIndex--;
            }
            else if ($scope.imgIndex == 0) {
                $scope.imgIndex = imagesArr.length - 1;
            }
        };

        /*init */
        $scope.init = function () {
            $http.get(app.version + 'posts/' + post.id).then(function (response) {
                if (response.data.status == 'success') {
                    $scope.data = response.data.data;
                    $scope.images = function (imagesArr) {
                        return imagesArr[$scope.imgIndex].src.url;
                    };
                    $scope.getComments($scope.dataComments);

                }
            });

        };

        $scope.init();
    }
});