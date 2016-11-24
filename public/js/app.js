var app = angular.module("wevivu", ['ngMaterial', 'ngRoute', 'wu.masonry', 'ngFileUpload']);
app.version = '/api/v1/';
app.user_id = $('meta[userid]').attr('userid');

app.config(function ($routeProvider) {
    $routeProvider
        .when("/", {
            templateUrl: '/pages/home/home.tmpl.html',
            controller: 'HomeController'
        })
        .otherwise({
            redirectTo: '/'
        });
});