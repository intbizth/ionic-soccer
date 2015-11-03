class personalDetail extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Personals, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    personalId = $stateParams.id || ''
    personals = new Personals()

    $scope.personal =
        item: {}
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            personals.$getId(id: personalId
            , (success) ->
                $this.item = success
                GoogleAnalytics.trackView 'personal-detail ' + $this.item.fullname
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(pull: yes)

    $scope.personal.loadData()
    $ionicLoading.show()
