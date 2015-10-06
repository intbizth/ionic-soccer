class Update extends Controller then constructor: (
    $scope, $ionicLoading, Papers, Und
) ->

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

    papersStore = new Papers null,
        url: Papers::url
        state: pageSize: 10

    options =
        scope: $scope
        storeKey: 'papersStore'
        collectionKey: 'papersCollection'

    $scope.papers =
        items: []
        hasMorePage: no
        loadData: ->
            promise = papersStore.load options
            promise.then ->
                $scope.papers.items = Und.map papersStore.getCollection(), (item) ->
                    return item.dataTranformToUpdate()
                $scope.papers.hasMorePage = papersStore.hasMorePage()
                $ionicLoading.hide()
            , $ionicLoading.hide()
        refresh: ->
            options.fetch = yes
            promise = papersStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.papers.items = Und.map papersStore.getCollection(), (item) ->
                    return item.dataTranformToUpdate()
                $scope.papers.hasMorePage = papersStore.hasMorePage()
        loadNext: ->
            papersStore.prepend = yes
            promise = papersStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = papersStore.getCollection().slice 0, papersStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToUpdate()
                $scope.papers.items = $scope.papers.items.concat items
                $scope.papers.hasMorePage = papersStore.hasMorePage()

    $scope.papers.loadData()

    $ionicLoading.show()
