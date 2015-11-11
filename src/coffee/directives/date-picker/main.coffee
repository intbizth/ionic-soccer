class DatePicker extends Directive then constructor: (
    $compile, Moment
) ->
    return {
        restrict: 'A'
        transclude: yes
        scope:
            min: '@'
            max: '@'
        templateUrl: 'templates/common/date-picker.html'
        link: (scope, element, attrs, controller, transclude) ->
            console.warn 'link', scope, element, attrs

            elementInput = element.find('input')
#            elementInput.attr 'ng-change',
                return
            return
    }
