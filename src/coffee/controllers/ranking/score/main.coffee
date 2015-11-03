class rankingScore extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, GamesScores, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'score'

    pageLimit = 20
    gamesScores = new GamesScores()

    $scope.score =
        items: []
        next: null
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            gamesScores.$getPage(
                page: 1
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = success.items
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
        loadNext: ->
            $this = @
            papers.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.score.loadData()
    $ionicLoading.show()
