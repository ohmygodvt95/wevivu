app.controller('NewPostController', function ($scope, $mdDialog, Data) {
    $scope.transfer = null;
    $scope.newPost = function (ev) {
        $mdDialog.show({
            controller: DialogController,
            templateUrl: '/pages/post_new.tmpl.html',
            parent: angular.element(document.body),
            targetEvent: ev,
            clickOutsideToClose: false
        }).then(function (res) {
            $scope.transfer = res.data;
        });
    };

    $scope.$watch('transfer', function (newValue, oldValue) {
        if (newValue !== oldValue) {
            Data.setData($scope.transfer);
            console.log(1);
        }
    });

    function DialogController($scope, $http, $timeout, Upload) {
        $scope.doing = false;
        $scope.sending = false;
        // MOdel
        $scope.post = {
            user_id: app.user_id,
            body: '',
            images: [],
            location: {
                name: 'Ha Noi, Viet Nam',
                lat: 21.0227732,
                long: 105.801944
            }
        };
        //Upload Images
        Upload.setDefaults({ngfKeep: true, ngfPattern:'image/*'});
        $scope.$watch('files', function (files) {
            if (files != null) {
                // console.log(files);
                if(files.length > 0){
                    $scope.doing = true;
                    $scope.file = files[files.length - 1];
                    files.length = 0;
                    Upload.upload({
                        url: app.version + 'images',
                        method: 'POST',
                        data: {file: $scope.file}
                    }).then(function (response) {
                        if(response.data.status == 'success'){
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

        //console.log($scope.location.name);
        $scope.markerLatLng = new google.maps.LatLng($scope.post.location.lat, $scope.post.location.long);
        $scope.infoWindow = new google.maps.InfoWindow;

        $scope.cancel = function () {
            $mdDialog.cancel();
        };

        $scope.fromNow = function (time) {
            return moment(time).fromNow();
        };

        $scope.init = function () {
            //init map
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

                            $scope.$apply(function(){
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
            $scope.map.addListener('click', function(event){
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
            $scope.map.addListener('bounds_changed', function() {
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
            $http.post(app.version + 'posts', {post: $scope.post}).then(function (res) {
                $scope.sending = false;
                $mdDialog.hide(res.data);
            }, function () {
                alert("Please! Try again.");
            });
        };

        $timeout(function () {
            $scope.init();
        }, 100);
    }
});