app.directive('inputComment', function () {
    return function (scope, element, attrs) {
        element.bind("keydown keypress", function (event) {
            if(event.which === 13) {
                scope.$apply(function (){
                    scope.$eval(attrs.inputComment);
                });
                event.preventDefault();
            }
        });
    };
});