class Timeline extends Controller then constructor: (
    $scope, $ionicLoading, $cordovaSocialSharing, Papers, Und
) ->
    $scope.share = (message, subject, file, link) ->
        message = message || ''
        subject = subject || ''
        file = file || ''
        link = link || ''
        $cordovaSocialSharing.share(message, subject, file, link).then (result) ->
            return
        , (error) ->
            return

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
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.papers.items = Und.map papersStore.getCollection(), (item) ->
                    return item.dataTranformToTimeline()
                $scope.papers.hasMorePage = papersStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            promise = papersStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.papers.items = Und.map papersStore.getCollection(), (item) ->
                    return item.dataTranformToTimeline()
                $scope.papers.hasMorePage = papersStore.hasMorePage()
        loadNext: ->
            papersStore.prepend = yes
            promise = papersStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = papersStore.getCollection().slice 0, papersStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToTimeline()
                $scope.papers.items = $scope.papers.items.concat items
                $scope.papers.hasMorePage = papersStore.hasMorePage()

    $scope.papers.loadData()

    $ionicLoading.show()
