class CompetitionTableFixture extends Controller then constructor: (
#    $scope, $ionicHistory, $timeout, Und, Chance
    $scope, Matches, $timeout, Und
) ->
    promise = null
    store = new Matches null,
#        url: Matches::url + 'nexts/28'
        url: Matches::url
        state: pageSize: 20
    options =
        scope: $scope

    $scope.matchLabel =
        items: []
        hasMorePage: no
        loadData: ->
            promise = store.load options
            promise.then ->
                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture(store.getCollection())
                $scope.matchLabel.hasMorePage = store.hasMorePage()
                console.log('loadData:items', JSON.stringify($scope.matchLabel.items))
                console.log('loadData:hasMorePage', $scope.matchLabel.hasMorePage)
                return
            return
        refresh: ->
            promise = store.fetch options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture(store.getCollection())
                $scope.matchLabel.hasMorePage = store.hasMorePage()
                console.log('refresh:items', JSON.stringify($scope.matchLabel.items))
                console.log('refresh:hasMorePage', $scope.matchLabel.hasMorePage)
                return
            return
        loadNext: ->
            promise = store.fetch options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = store.dataTranform.competitionTable.fixture(store.getCollection())
                for item in items
                    $scope.matchLabel.items.push item
                $scope.matchLabel.hasMorePage = store.hasMorePage()
                console.log('loadNext:items', JSON.stringify(items))
                console.log('loadNext:hasMorePage', $scope.matchLabel.hasMorePage)
                return
            return

    $scope.matchLabel.loadData()
