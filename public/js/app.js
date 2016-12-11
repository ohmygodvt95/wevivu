var app = angular.module("wevivu", ['ngMaterial', 'ngRoute', 'wu.masonry', 'ngFileUpload', 'infinite-scroll', 'ngToast']);
app.version = '/api/v1/';
app.user_id = $('meta[userid]').attr('userid');

app.config(function ($routeProvider, $mdDateLocaleProvider) {
    $mdDateLocaleProvider
        .formatDate = function(date) {
            return date ? moment(date).format('YYYY-MM-DD') : '';
    };

    $routeProvider
        .when("/", {
            templateUrl: '/pages/home/home.tmpl.html',
            controller: 'HomeController'
        })
        .when("/wall/:user_id", {
            templateUrl: '/pages/wall/wall.tmpl.html',
            controller: 'WallController'
        })
        .when("/wall/:user_id/profile", {
            templateUrl: '/pages/wall/profile.tmpl.html',
            controller: 'ProfileController'
        })
        .when('/error', {
            templateUrl: '/pages/404.tmpl.html',
        })
        .otherwise({
            redirectTo: '/'
        });
});