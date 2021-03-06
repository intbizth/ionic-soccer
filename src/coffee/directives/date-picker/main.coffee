class DatePicker extends Directive then constructor: (
    $ionicModal, $ionicScrollDelegate, $translate, Moment
) ->
    return {
        restrict: 'A'
        require: 'ngModel'
        transclude: yes
        replace: yes
        scope:
            min: '@'
            max: '@'
        templateUrl: 'templates/directives/date-picker/main.html'
        link: (scope, element, attrs, controller) ->
            scope.day = 0
            scope.month = 0
            scope.year = 0
            scope.days = []
            scope.months = []
            scope.years = []
            scope.select = null
            scope.translate =
                unit:
                    day: 'day'
                    month: 'month'
                    year: 'year'
                title:
                    day: 'select_day'
                    month: 'select_month'
                    year: 'select_year'

            $ionicModal.fromTemplateUrl(
                'templates/directives/date-picker/overlay.html',
                 scope: scope
            ).then (modal) ->
                scope.modal = modal
                return

            init = ->
                createYears()
                createMonths()
                createDays()

            tranformData = (value) ->
                regExpDate = new RegExp('^\\d{4}-\\d{2}-\\d{2}$')
                if !regExpDate.test(value)
                    value = '0000-00-00'

                value = value.split('-')
                scope.day = parseInt value[2]
                scope.month = parseInt value[1]
                scope.year = parseInt value[0]
                return

            bindData = ->
                year = '0000'
                month = '00'
                day = '00'

                if scope.year > 0
                    year = scope.year

                if scope.month > 0
                    month = parseInt scope.month
                    if month < 10
                        month = '0' + month

                if scope.day > 0
                    day = parseInt scope.day
                    if day < 10
                        day = '0' + day

                controller.$setViewValue year + '-' + month + '-' + day
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
                return
            )

            scope.$watch(->
                return scope.month
            , (value) ->
                createDays()
                bindData()
                return
            )

            scope.$watch(->
                return scope.year
            , (value) ->
                createDays()
                bindData()
                return
            )

            scope.$on 'modal.hidden', ->
                scope.select = null
                $ionicScrollDelegate.scrollTop no

            $translate(
                [
                    'date_picker.unit.day'
                    'date_picker.unit.month'
                    'date_picker.unit.year'
                    'date_picker.title.day'
                    'date_picker.title.month'
                    'date_picker.title.year'
                ]
            ).then((translations) ->
                scope.translate.unit.day = translations['date_picker.unit.day']
                scope.translate.unit.month = translations['date_picker.unit.month']
                scope.translate.unit.year = translations['date_picker.unit.year']
                scope.translate.title.day = translations['date_picker.title.day']
                scope.translate.title.month = translations['date_picker.title.month']
                scope.translate.title.year = translations['date_picker.title.year']
            )

            init()
            return
    }
