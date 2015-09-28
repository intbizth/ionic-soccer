class MatchEvents extends Directive then constructor: (
    $timeout, Und
) ->
    return {
        restrict: 'E'
        transclude: true
        scope: {
            items: '=items'
        }
        templateUrl: 'templates/directive/match-events/main.html'
        controller: ->
            matchEvents = document.getElementById 'match-events'
            matchEventsLine = document.getElementById 'match-events-line'

            matchEventsLine.style.height = '0px';

            $timeout(->
                matchEventsLine.style.height = (parseInt(matchEvents.offsetHeight) - 12) + 'px';
            ,500)
    }
