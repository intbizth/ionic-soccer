class MatchLabel extends Directive then constructor: (
    $timeout, Und
) ->
    return {
        restrict: 'E'
        transclude: true
        scope: {
            items: '=items'
        }
        templateUrl: 'templates/directives/match-label/main.html'
    }
