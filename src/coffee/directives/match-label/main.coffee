class MatchLabel extends Directive then constructor: (
    $timeout, Und
) ->
    return {
        restrict: 'E'
        transclude: true
        scope: {
            sections: '=sections'
        }
        templateUrl: 'templates/directives/match-label/main.html'
    }
