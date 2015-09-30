class RankingList extends Directive then constructor: (
    $timeout, Und
) ->
    return {
        restrict: 'E'
        transclude: true
        scope: {
            data: '=data'
        }
        templateUrl: 'templates/directives/ranking-list/main.html'
    }
