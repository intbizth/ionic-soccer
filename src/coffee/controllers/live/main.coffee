class LiveMain extends Controller then constructor: (
    $scope, $ionicHistory, $ionicLoading, Matches, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    clubId = 28
    promise = null

    matchStore = new Matches null,
        url: Matches::url + 'live/' + clubId
        state: pageSize: 1

    options =
        scope: $scope
        matchStoreKey: 'matchStore'
        collectionKey: 'matchCollection'

    $scope.matchLabel =
        items: []
        loadData: ->
            promise = matchStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.matchLabel.items = Und.map matchStore.getCollection(), (item) ->
                    $scope.steaming.item.url = item.steaming
                    $scope.matchEvents.items = item.dataTranformToMatchEvent()
                    return item.dataTranformToLive()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = matchStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.matchLabel.items = Und.map matchStore.getCollection(), (item) ->
                    $scope.steaming.item.url = item.steaming
                    $scope.matchEvents.items = item.dataTranformToMatchEvent()
                    return item.dataTranformToLive()

    $scope.matchLabel.loadData()

    $ionicLoading.show()

    $scope.steaming =
        item: url: null

    $scope.matchEvents =
        items: []
        match:
            halftime: no
            end: no

    $scope.refresh = ->
        $scope.matchLabel.refresh()
