class TimeAgo extends Directive then constructor: (
    $compile, $interval, Moment
) ->
    return {
        restrict: 'A'
        scope:
            datetime: '@'
        link: (scope, element, attrs) ->
            convert = (datetime) ->
                element.html ''
                element.append Moment(datetime).fromNow()

            convert scope.datetime

            $interval(->
                convert scope.datetime
            , 60000)
    }
