class rankingPlayerDetail extends Controller then constructor: (
    $scope, $ionicHistory, $ionicPlatform, $timeout, GoogleAnalytics, Und, Chance
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView $state.current.name

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.ranking =
        item: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('ranking:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'ranking:doRefresh'
            $this = this
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                id: Und.random(1, 9999999)
                name: profile.name
                photo: profile.image.src
                prediction: Und.random(1, 9999999)
                score: Und.random(1, 9999999)
                player: Und.random(1, 9999999)
            return item

    $scope.seasons =
        item: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('seasons:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'seasons:doRefresh'
            $this = this
            $timeout(->
                console.log 'seasons:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                predict: Und.random(0, 999)
                right: Und.random(0, 999)
                sum: Und.random(0, 999)
                accuracy: Chance.floating({min: 0, max: 100, fixed: 2});
            return item

#    promise = null
#
#    store = new Matches null,
#        url: Matches::url + 'nexts/28'
#        state: pageSize: 20
#
#    options =
#        scope: $scope
#        storeKey: 'matchStore'
#        collectionKey: 'matchCollection'
#
#    $scope.matchLabel =
#        items: []
#        hasMorePage: no
#        loadData: ->
#            promise = store.load options
#            promise.then ->
#                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture store.getCollection()
#                $scope.matchLabel.hasMorePage = store.hasMorePage()
#                $ionicLoading.hide()
#            , $ionicLoading.hide()
#        refresh: ->
#            options.fetch = yes
#            promise = store.getFirstPage options
#            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
#            promise.then ->
#                $scope.matchLabel.items = store.dataTranform.competitionTable.fixture store.getCollection()
#                $scope.matchLabel.hasMorePage = store.hasMorePage()
#        loadNext: ->
#            store.prepend = yes
#            promise = store.getNextPage options
#            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
#            promise.then ->
#                items = store.dataTranform.competitionTable.fixture(store.getCollection().slice 0, store.state.pageSize)
#                $scope.matchLabel.items = $scope.matchLabel.items.concat(items)
#                $scope.matchLabel.hasMorePage = store.hasMorePage()
#
#    $ionicLoading.show(
#        noBackdrop: no
#        template: '<i class="icon ion-ios-close-empty activity-icon"></i><div class="activity-text">Loading...</div>'
#    )

    $scope.ranking.loadData()
    $scope.seasons.loadData()
#    $scope.matchLabel.loadData()

    $scope.data =
        doRefresh: ->
            $scope.ranking.doRefresh()
            $scope.seasons.doRefresh()
