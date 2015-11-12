class DatePicker extends Directive then constructor: (
    $ionicModal, $ionicScrollDelegate, Moment
) ->
    return {
        restrict: 'A'
        require: 'ngModel'
        transclude: yes
        replace: yes
        scope:
            min: '@'
            max: '@'
        templateUrl: 'templates/common/date-picker/main.html'
        link: (scope, element, attrs, controller) ->
            scope.day = 0
            scope.month = 0
            scope.year = 0
            scope.days = []
            scope.months = []
            scope.years = []
            scope.select = null
            scope.texts =
                day: 'Day'
                month: 'Month'
                year: 'Year'
            scope.titles =
                day: 'Select day'
                month: 'Select month'
                year: 'Select year'

            $ionicModal.fromTemplateUrl(
                'templates/common/date-picker/overlay.html',
                 scope: scope
            ).then (modal) ->
                scope.modal = modal
                return

            init = ->
                createYears()
                createMonths()
                createDays()

            tranformData = (value) ->
                date = Moment(value)
                scope.day = parseInt date.format 'D'
                scope.month = parseInt date.format 'M'
                scope.year = parseInt date.format 'YYYY'

                if isNaN scope.day then scope.day = 0
                if isNaN scope.month then scope.month = 0
                if isNaN scope.year then scope.year = 0
                return

            bindData = ->
                date = ''
                if scope.year > 0 and scope.month > 0 and scope.day > 0
                    date = Moment([scope.year, scope.month - 1, scope.day]).format('YYYY-MM-DD')
                controller.$setViewValue date
                return

            createDays = ->
                scope.days = []
                min = 1
                max = 31
                if scope.year > 0 and scope.month > 0
                    max = parseInt Moment([scope.year, scope.month - 1]).endOf('month').format('D')
                    if scope.day > max then scope.day = 0
                while min <= max
                    scope.days.push min++
                return

            createMonths = ->
                scope.months = []
                min = 1
                max = 12
                while min <= max
                    scope.months.push min++
                return

            createYears = ->
                scope.years = []
                min = Moment(attrs.min).format 'YYYY'
                max = Moment(attrs.max).format 'YYYY'
                while min <= max
                    scope.years.push min++
                return

            scope.getMonthShortName = (month) ->
                return Moment([0, month - 1]).format('MMM')

            scope.getMonthFullName = (month) ->
                return Moment([0, month - 1]).format('MMMM')

            scope.openDay = ->
                scope.select = 'day'
                scope.modal.show()

            scope.openMonth = ->
                scope.select = 'month'
                scope.modal.show()

            scope.openYear = ->
                scope.select = 'year'
                scope.modal.show()

            scope.selectData = (select, value)->
                scope[select] = value
                scope.modal.hide()

            scope.$watch(->
                return controller.$modelValue
            , (value) ->
                tranformData value
            )

            scope.$watch(->
                return scope.day
            , (value) ->
                bindData()
            )

            scope.$watch(->
                return scope.month
            , (value) ->
                createDays()
                bindData()
            )

            scope.$watch(->
                return scope.year
            , (value) ->
                createDays()
                bindData()
            )

            scope.$on 'modal.hidden', ->
                scope.select = null
                $ionicScrollDelegate.scrollTop no

            init()
            return
    }
