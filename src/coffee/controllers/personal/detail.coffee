class personalDetail extends Controller then constructor: (
    $ionicHistory, $scope, $stateParams, $timeout, GoogleAnalytics, LoadingOverlay, Personals
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'personal-detail'
        , 200)
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
                    LoadingOverlay.hide 'personal-detail'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'personal-detail'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'

    $scope.personal.loadData()
    LoadingOverlay.show 'personal-detail'
