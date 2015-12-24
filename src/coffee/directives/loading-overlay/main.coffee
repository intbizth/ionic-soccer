class LoadingOverlay extends Directive then constructor: (

) ->
    return {
        restrict: 'E'
        transclude: yes
        replace: yes
        scope:
            id: '@'
        templateUrl: 'templates/directives/loading-overlay/main.html'
        link: (scope, element, attrs) ->
            console.warn(scope, element, attrs)
            element[0].id = 'loading-overlay-id-' + element[0].id
            element.addClass element[0].id
            element.addClass 'loading-overlay-hide'
            console.warn(scope, element, attrs)
            return
    }
