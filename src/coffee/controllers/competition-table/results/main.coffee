class CompetitionTableResult extends Controller then constructor: (
    $scope, $ionicLoading, Matches, Und
) ->
    promise = null

    matchStore = new Matches null,
        url: Matches::url + 'nexts/28'
        state: pageSize: 20

    options =
        scope: $scope
        matchStoreKey: 'matchStore'
        collectionKey: 'matchCollection'

    $scope.matchLabel =
        items: []
        hasMorePage: no
        loadData: ->
            promise = matchStore.load options
            promise.then ->
                $scope.matchLabel.items = matchStore.dataTranform.competitionTable.fixture matchStore.getCollection()
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()
                $ionicLoading.hide()
            , $ionicLoading.hide()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = matchStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.matchLabel.items = matchStore.dataTranform.competitionTable.fixture matchStore.getCollection()
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()
        loadNext: ->
            matchStore.prepend = yes
            promise = matchStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = matchStore.dataTranform.competitionTable.fixture(matchStore.getCollection().slice 0, matchStore.state.pageSize)
                $scope.matchLabel.items = $scope.matchLabel.items.concat(items)
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()

    $scope.matchLabel.loadData()

    $ionicLoading.show()
