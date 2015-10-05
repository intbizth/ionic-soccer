class CompetitionTableFixture extends Controller then constructor: (
    $scope, $ionicLoading, Matches, Und
) ->
    promise = null

    store = new Matches null,
        url: Matches::url + 'nexts/28'
        state: pageSize: 20

    options =
        scope: $scope
        storeKey: 'matchStore'
        collectionKey: 'matchCollection'

    $scope.matchLabel =
        items: []
        hasMorePage: no
        loadData: ->
            promise = store.load options
            promise.then ->
                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture store.getCollection()
                $scope.matchLabel.hasMorePage = store.hasMorePage()
                $ionicLoading.hide()
            , $ionicLoading.hide()
        refresh: ->
            options.fetch = yes
            promise = store.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture store.getCollection()
                $scope.matchLabel.hasMorePage = store.hasMorePage()
        loadNext: ->
            store.prepend = yes
            promise = store.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = store.dataTranform.competitionTable.fixture(store.getCollection().slice 0, store.state.pageSize)
                $scope.matchLabel.items = $scope.matchLabel.items.concat(items)
                $scope.matchLabel.hasMorePage = store.hasMorePage()

    $scope.matchLabel.loadData()

    $ionicLoading.show(
        noBackdrop: no
        template: '<p><ion-spinner></ion-spinner></p>'
    )
