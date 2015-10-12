class FanzoneWallpapers extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, Wallpapers, Und
) ->
    wallpaperStore = new Wallpapers null,
        url: Wallpapers::url + 'club/' + $rootScope.clubId
        state: pageSize: 20

    options =
        scope: $scope
        wallpaperStoreKey: 'wallpaperStore'
        collectionKey: 'wallpaperCollection'

    $scope.wallpapers =
        items: []
        hasMorePage: no
        loadData: ->
            promise = wallpaperStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.wallpapers.items = Und.map wallpaperStore.getCollection(), (item) ->
                    return item.dataTranformToFanzone()
                $scope.wallpapers.hasMorePage = wallpaperStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = wallpaperStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.wallpapers.items = Und.map wallpaperStore.getCollection(), (item) ->
                    return item.dataTranformToFanzone()
                $scope.wallpapers.hasMorePage = wallpaperStore.hasMorePage()
        loadNext: ->
            wallpaperStore.prepend = yes
            promise = wallpaperStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = wallpaperStore.getCollection().slice 0, wallpaperStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToFanzone()
                $scope.wallpapers.items = $scope.wallpapers.items.concat items
                $scope.wallpapers.hasMorePage = wallpaperStore.hasMorePage()

    $scope.wallpapers.loadData()

    $ionicLoading.show()
    