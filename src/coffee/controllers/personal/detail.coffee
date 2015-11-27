class personalDetail extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Personals
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.title = ''

    personalId = $stateParams.id || ''
    personals = new Personals()

    $scope.personal =
        item: {}
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            if !pull
                $this.loaded = no
            personals.$getId(id: personalId
            , (success) ->
                $this.loaded = yes
                $this.item = success
                $scope.title = $this.item.fullname
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
