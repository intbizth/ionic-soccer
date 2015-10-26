class CompetitionTablePositionTable extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, $cordovaGoogleAnalytics, $state, Rankings, Und
) ->
    $cordovaGoogleAnalytics.trackView position-table

    rankingStore = new Rankings null,
        url: Rankings::url + 'fixtures/tpl/2015-2016'
        state: pageSize: 100

    options =
        scope: $scope
        rankingStoreKey: 'rankingStore'
        collectionKey: 'rankingCollection'

    $scope.position =
        items: []
        hasMorePage: no
        loadData: ->
            promise = rankingStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.position.items = Und.map rankingStore.getCollection(), (item) ->
                    return item.dataTranformToPostionTable()
                $scope.position.hasMorePage = rankingStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = rankingStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                # FIXBUG
                items = rankingStore.getCollection().slice 0, $scope.position.items.length
                $scope.position.items = Und.map items, (item) ->
                    return item.dataTranformToPostionTable()
                $scope.position.hasMorePage = rankingStore.hasMorePage()
        loadNext: ->
            rankingStore.prepend = yes
            promise = rankingStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = rankingStore.getCollection().slice 0, rankingStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToPostionTable()
                $scope.position.items = $scope.position.items.concat items
                $scope.position.hasMorePage = rankingStore.hasMorePage()

    $scope.position.loadData()

    $ionicLoading.show()
