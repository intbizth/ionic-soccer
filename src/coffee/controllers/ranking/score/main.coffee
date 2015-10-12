class rankingScore extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, GamesScores, Und
) ->
    gamesScoreStore = new GamesScores null,
        url: GamesScores::url + 'result/' + $rootScope.clubId
        state: pageSize: 20

    options =
        scope: $scope
        gamesScoreStoreKey: 'gamesScoreStore'
        collectionKey: 'gamesScoreCollection'

    $scope.score =
        items: []
        hasMorePage: no
        loadData: ->
            promise = gamesScoreStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.score.items = Und.map gamesScoreStore.getCollection(), (item) ->
                    return item.dataTranformToGamesScore()
                $scope.score.hasMorePage = gamesScoreStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = gamesScoreStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.score.items = Und.map gamesScoreStore.getCollection(), (item) ->
                    return item.dataTranformToGamesScore()
                $scope.score.hasMorePage = gamesScoreStore.hasMorePage()
        loadNext: ->
            gamesScoreStore.prepend = yes
            promise = gamesScoreStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = gamesScoreStore.getCollection().slice 0, gamesScoreStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToGamesScore()
                $scope.score.items = $scope.score.items.concat items
                $scope.score.hasMorePage = gamesScoreStore.hasMorePage()

    $scope.score.loadData()

    $ionicLoading.show()
