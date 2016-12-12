app.controller('HomeController', function ($scope, $http, $mdDialog, Data, ngToast, $interval, $timeout) {

    $scope.transfer = null;
    $scope.busy = false;

    $scope.currentData = {
        query: '',
        mode: 'new',
        after: 0,
        before: 0,
        total: 0,
        limit: 10,
        data: []
    };


    $scope.isOwn = function (user_id) {
        return user_id == app.user_id;
    };

    function isContrain(e, arr) {
        for (var i = 0; i < arr.length; i++) {
            if (e.id == arr[i].id) return true;
        }
        return false;
    }



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
    };

    $scope.getUserData = function () {
        $http.get(app.version + 'users/' + app.user_id).then(function (response) {
            $scope.user = response.data.data;
            $(document).ready(function () {
                $("#tabs").sticky({topSpacing: 79});
            });
        });
    };
    /*change mode*/
    $scope.changeMode = function (mode) {
        $scope.currentData.mode = mode;
        $scope.currentData.after = 0;
        $scope.currentData.before = 0;
        $scope.currentData.total = 0;
        $scope.currentData.query = "";
        $scope.currentData.data.length = 0;
        $scope.getPosts($scope.currentData);

    };

    $scope.search = function (mode) {
        $scope.currentData.mode = mode;
        $scope.currentData.after = 0;
        $scope.currentData.before = 0;
        $scope.currentData.total = 0;
        $scope.currentData.data.length = 0;
    };
    $scope.searchBegin = function (query) {
        $scope.currentData.after = 0;
        $scope.currentData.before = 0;
        $scope.currentData.total = 0;
        $scope.currentData.data.length = 0;
        $scope.currentData.query = query;
        $scope.getPosts($scope.currentData);
    };

    /*bookmark*/
    $scope.createBookmark = function (post) {
        $http.post(app.version + 'bookmarks', {
            bookmark: {
                user_id: app.user_id,
                post_id: post.id
            }
        }).then(function (response) {
            ngToast.create(response.data.data);
            // console.log(response.data);
        });
    };

    /*Post get*/
    $scope.editPost = function (ev, post) {
        $mdDialog.show({
            locals: {post: post},
            controller: EditPostController,
            templateUrl: '/pages/post_edit.tmpl.html',
            parent: angular.element(document.body),
            targetEvent: ev,
            clickOutsideToClose: false
        }).then(function (data) {
            console.log(data);
            $scope.currentData.data.forEach(function (v, i) {
                if(data.id == v.id){
                    console.log(1);
                    $scope.currentData.data.splice(i, 1);
                    $scope.currentData.data.unshift(data);
                    return true;
                }
            });
        });
    };
    function EditPostController($scope, $http, $timeout, Upload, post) {
        $scope.doing = false;
        $scope.sending = false;
        // MOdel
        // $scope.post = {
        //     user_id: app.user_id,
        //     body: '',
        //     images: [],
        //     location: {
        //         name: 'Ha Noi, Viet Nam',
        //         lat: 21.0227732,
        //         long: 105.801944
        //     }
        // };
        //Upload Images
        $scope.deleteImage = function (img) {
            $scope.post.images.forEach(function (v, i) {
                if (v.id == img.id) {
                    $scope.post.images.splice(i, 1);
                    return null;
                }
            });
        };

        Upload.setDefaults({ngfKeep: true, ngfPattern: 'image/*'});

        $scope.$watch('files', function (files) {
            if (files != null) {
                // console.log(files);
                if (files.length > 0) {
                    $scope.doing = true;
                    $scope.file = files[files.length - 1];
                    files.length = 0;
                    Upload.upload({
                        url: app.version + 'images',
                        method: 'POST',
                        data: {file: $scope.file}
                    }).then(function (response) {
                        if (response.data.status == 'success') {
                            $scope.post.images.push(response.data.data);
                            $scope.doing = false;
                        }
                    }, function () {
                        $scope.doing = false;
                    });
                }
            }
        });

        /*Map google api*/
        $scope.map = null;


        $scope.cancel = function () {
            $mdDialog.cancel();
        };

        $scope.fromNow = function (time) {
            return moment(time).fromNow();
        };

        $scope.init = function () {
            //init map
            //console.log($scope.location.name);
            $scope.markerLatLng = new google.maps.LatLng($scope.post.location.lat, $scope.post.location.long);
            $scope.infoWindow = new google.maps.InfoWindow;

            $scope.map = new google.maps.Map(document.getElementById('map'), {
                center: $scope.markerLatLng,
                zoom: 13
            });
            // geocoder
            function getInfo(event, string) {
                var geoCoder = new google.maps.Geocoder;

                geoCoder.geocode({'location': event}, function (results, status) {
                    if (status == 'OK') {
                        if (!results[1]) {
                            alert('No results found');
                        } else {
                            $scope.markerLatLng = event;
                            $scope.marker.setPosition($scope.markerLatLng);

                            $scope.$apply(function () {
                                $scope.post.location.name = string ? string : results[0].formatted_address;
                                $scope.post.location.lat = $scope.markerLatLng.lat();
                                $scope.post.location.long = $scope.markerLatLng.lng();
                            });

                            $scope.infoWindow.setContent($scope.post.location.name);
                            $scope.infoWindow.open($scope.map, $scope.marker);

                        }
                    } else {
                        alert('Geocoder failed due to: ' + status);
                    }
                });
            }

            $scope.map.addListener('click', function (event) {
                $scope.markerLatLng = event.latLng;
                getInfo($scope.markerLatLng);
            });

            $scope.marker = new google.maps.Marker({
                position: $scope.markerLatLng,
                map: $scope.map
            });

            //add input
            $scope.input = document.getElementById('pac-input');
            $scope.searchBox = new google.maps.places.SearchBox($scope.input);
            $scope.map.controls[google.maps.ControlPosition.TOP_LEFT].push($scope.input);
            // Bias the SearchBox results towards current map's viewport.
            $scope.map.addListener('bounds_changed', function () {
                $scope.searchBox.setBounds($scope.map.getBounds());
            });
            // target
            $scope.searchBox.addListener('places_changed', function () {
                var places = $scope.searchBox.getPlaces();
                if (places.length == 0) {
                    return;
                }
                // For each place, get the icon, name and location.
                var bounds = new google.maps.LatLngBounds();
                places.forEach(function (place) {
                    if (!place.geometry) {
                        console.log("Returned place contains no geometry");
                        return;
                    }

                    if (place.geometry.viewport) {
                        getInfo(place.geometry.location, place.formatted_address);
                        // Only geocodes have viewport.
                        bounds.union(place.geometry.viewport);
                    } else {
                        bounds.extend(place.geometry.location);
                    }
                });
                $scope.map.fitBounds(bounds);
            });
        };

        $scope.sendPost = function () {
            $scope.sending = true;
            $http.patch(app.version + 'posts/' + post.id, {post: $scope.post}).then(function (res) {
                $scope.sending = false;
                $mdDialog.hide(res.data.data);
            }, function () {
                alert("Please! Try again.");
            });
        };

        $timeout(function () {
            $http.get(app.version + "posts/" + post.id).then(function (response) {
                $scope.post = response.data.data.post;
                // console.log($scope.post);
                $scope.init();
            });
        }, 100);
    }
    $scope.createReport = function (post_id) {
        $http.post(app.version + 'report', {report: {user_id: app.user_id, post_id: post_id}}).then(function (res) {
            ngToast.create(res.data.data);
        }, function () {
            ngToast.create(res.data.data);
        });
    };
    $scope.deletePost = function (post) {
        $http.delete(app.version + 'posts/' + post.id).then(function (response) {
            //console.log(response.data);
            $scope.currentData.data.forEach(function (value, index) {
                if (value.id == response.data.data.id) {
                    $scope.currentData.data.splice(index, 1);
                    return 0;
                }
            });
        });
    };
    $scope.getPosts = function (data) {
        $scope.busy = true;
        if($scope.currentData.mode == 'search' && $scope.currentData.query.length == 0) return 0;
        $http.get(app.version + 'home/' + data.mode + '?after=' + data.after + "&user_id=" + app.user_id + "&limit=" + data.limit + "&query=" + data.query)
            .then(function (response) {
                if (response.data.total > 0) {
                    data.after = response.data.after;
                    data.before = response.data.before == 0 ? data.before : response.data.before;
                    for (var i = 0; i < response.data.data.length; i++) {
                        if (!isContrain(response.data.data[i], data.data))
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
    $scope.newPosts = 0;
    function checkNewPost(){
        if($scope.currentData.mode == 'new'){
            $http.get(app.version + 'realtime?before=' + $scope.currentData.before).then(function (res) {
                if(res.data.status == 'success'){
                    $scope.newPosts = res.data.data;
                    $timeout(function () {
                        $scope.newPosts = 0;
                    }, 5000);
                }
            });
        }
    }
    $scope.getNewPosts = function () {
        $http.get(app.version + 'realtime/new?before=' + $scope.currentData.before).then(function (res) {
            res.data.data.forEach(function (v, i) {
                if(!isContrain(v, $scope.currentData.data))
                    $scope.currentData.data.unshift(v);
            });
            $scope.currentData.before = res.data.before;
            $scope.newPosts = 0;
            $('body, html').animate({scrollTop: 0}, 500);
        });
    };
    /*int */
    $scope.init = function () {
        $scope.getUserData();
        $interval(checkNewPost, 15000);
    };
    $scope.init();

    /*Post detail*/
    function PostController($scope, $http, post, $timeout, $interval) {
        function isContrain(e, arr) {
            for (var i = 0; i < arr.length; i++) {
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
        function updateRate(p, rate, rates) {
            p.rate = rate;
            p.post.data.rates = rates
        }

        $scope.rate = function (p, point) {
            if (!p.rate) {
                $http.post(app.version + 'rates', {rate: {user_id: app.user_id, post_id: p.post.id, point: point}})
                    .then(function (response) {
                        updateRate(p, response.data.data.rate, response.data.data.rates);
                    });
            }
            else if (p.rate.point != point) {
                $http.patch(app.version + 'rates', {rate: {user_id: app.user_id, post_id: p.post.id, point: point}})
                    .then(function (response) {
                        updateRate(p, response.data.data.rate, response.data.data.rates);
                    });
            }
            else {

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
                    if (v.id == response.data.data.id) {
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
                $http.post(app.version + 'comments', {
                    comment: {
                        user_id: app.user_id,
                        post_id: $scope.data.post.id,
                        body: body
                    }
                })
                    .then(function (response) {
                        if (response.data.status == 'success') {
                            if (!isContrain(response.data.data.comment, $scope.dataComments.data)) {
                                $scope.dataComments.data.push(response.data.data.comment);
                                $scope.data.post.data.comments = response.data.data.comments;
                                $scope.comment = '';
                                $scope.dataComments.total++;
                            }
                        }
                    });
        };

        $scope.getComments = function (data) {
            $scope.busy = true;
            $http.get(app.version + 'comments?post_id=' + $scope.data.post.id + "&after=" + data.after + "&limit=" + data.limit)
                .then(function (response) {
                    if (response.data.total > 0) {
                        data.after = response.data.after;
                        data.before = response.data.before == 0 ? data.before : response.data.before;
                        for (var i = 0; i < response.data.data.length; i++) {
                            if (!isContrain(response.data.data[i], data.data)) {
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

                    $timeout(function () {
                        $interval(function () {
                            $http.get(app.version + 'posts/' + post.id).then(function (response) {
                                $scope.data = response.data.data;
                            });
                        }, 10000);
                    }, 5000);

                    $timeout(function () {
                        $interval(function () {
                            $http.get(app.version
                                + "realtime/comments?before="
                                + $scope.dataComments.before
                                + "&post_id=" + $scope.data.post.id
                                + "&limit=" + 10).then(function (res) {
                                res.data.data.forEach(function (v, i) {
                                    if(!isContrain(v, $scope.dataComments.data)) $scope.dataComments.data.unshift(v);
                                });
                                $scope.dataComments.before = res.data.before;
                            });
                        }, 5000);
                    }, 5000);

                }
            });

        };

        $scope.init();
    }
});
