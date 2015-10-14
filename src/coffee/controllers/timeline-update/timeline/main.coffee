class Timeline extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, $cordovaSocialSharing, MicroChats, Und
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

    microChatsStore = new MicroChats null,
        url: MicroChats::url + 'latest/' + $rootScope.clubId
        state: pageSize: 20

    options =
        scope: $scope
        storeKey: 'microChatsStore'
        collectionKey: 'microChatsCollection'

    $scope.microChats =
        items: []
        hasMorePage: no
        loadData: ->
            promise = microChatsStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.microChats.items = Und.map microChatsStore.getCollection(), (item) ->
                    return item.dataTranformToTimeline()
                $scope.microChats.hasMorePage = microChatsStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            promise = microChatsStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.microChats.items = Und.map microChatsStore.getCollection(), (item) ->
                    return item.dataTranformToTimeline()
                $scope.microChats.hasMorePage = microChatsStore.hasMorePage()
        loadNext: ->
            microChatsStore.prepend = yes
            promise = microChatsStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = microChatsStore.getCollection().slice 0, microChatsStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToTimeline()
                $scope.microChats.items = $scope.microChats.items.concat items
                $scope.microChats.hasMorePage = microChatsStore.hasMorePage()

    $scope.microChats.loadData()

    $ionicLoading.show()
