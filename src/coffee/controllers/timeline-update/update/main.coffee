class Update extends Controller then constructor: (
    $scope, $ionicLoading, News, Und
) ->
    $scope.data =
        next: no
        doRefresh: ->
            $scope.ticket.loadData()
            $scope.news.doRefresh()
            return
        loadMore: ->
            $scope.news.loadMore()
            return

#    $scope.ticket =
#        items: [],
#        loadData: ->
#            items = @fakeItems()
#            i = 1
#            for item in items
#                if i == 1
#                    item.class = 'first'
#                else if i == 2
#                    item.class = 'second'
#                else if i == 3
#                    item.class = 'third'
#                i++
#                if i > 3
#                    i = 1
#            @items =  items
#            console.log('ticket:loadData', @items.length, JSON.stringify(@items))
#            return
#        fakeItem: ->
#            item =
#                id: Und.random(1, 9999999)
#                seats: []
#                textSeats: ''
#                count: Und.random(0, 9999)
#            i = 0
#            ii = Und.random(1, 20)
#            while i < ii
#                item.seats.push Chance.character(
#                    alpha: yes
#                    casing: 'upper'
#                )
#                i++
#            item.seats = Und.uniq item.seats
#            item.seats.sort()
#            item.textSeats = item.seats.join ', '
#            return item
#        fakeItems: ->
#            items = []
#            i = 0
#            ii = Und.random(0, 2)
#            while i < ii
#                items.push @fakeItem()
#                i++
#            return items

    promise = null

    store = new News null,
        url: News::url
        state: pageSize: 20

    options =
        scope: $scope
        storeKey: 'newsStore'
        collectionKey: 'newsCollection'

    $scope.news =
        items: []
        hasMorePage: no
        loadData: ->
            promise = store.load options
            promise.then ->
                $scope.news.items = store.dataTranform.competitionTable.fixture store.getCollection()
                $scope.news.hasMorePage = store.hasMorePage()
                $ionicLoading.hide()
            , $ionicLoading.hide()
        refresh: ->
            options.fetch = yes
            promise = store.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.news.items = store.dataTranform.competitionTable.fixture store.getCollection()
                $scope.news.hasMorePage = store.hasMorePage()
        loadNext: ->
            store.prepend = yes
            promise = store.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = store.dataTranform.competitionTable.fixture(store.getCollection().slice 0, store.state.pageSize)
                $scope.news.items = $scope.news.items.concat(items)
                $scope.news.hasMorePage = store.hasMorePage()

    $scope.news.loadData()
