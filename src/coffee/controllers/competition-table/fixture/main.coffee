class CompetitionTableFixture extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, $cordovaGoogleAnalytics, $state, Matches, Und
) ->
    $cordovaGoogleAnalytics.trackView fixture

    matchStore = new Matches null,
        url: Matches::url + 'nexts/' + $rootScope.clubId
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
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.matchLabel.items = Und.map matchStore.getCollection(), (item) ->
                    return item.dataTranformToFixture()
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = matchStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.matchLabel.items = Und.map matchStore.getCollection(), (item) ->
                    return item.dataTranformToFixture()
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()
        loadNext: ->
            matchStore.prepend = yes
            promise = matchStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = matchStore.getCollection().slice 0, matchStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToFixture()
                $scope.matchLabel.items = $scope.matchLabel.items.concat items
                $scope.matchLabel.hasMorePage = matchStore.hasMorePage()

    $scope.matchLabel.loadData()

    $ionicLoading.show()
