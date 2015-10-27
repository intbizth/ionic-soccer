class FanzoneWallpapers extends Controller then constructor: (
    $cordovaGoogleAnalytics, $cordovaFileTransfer, $ionicLoading, $ionicPlatform, $ionicPopup, $rootScope, $scope, $timeout, md5, Und, Wallpapers
) ->
    $ionicPlatform.ready ->
        $cordovaGoogleAnalytics.trackView 'wallpapers'

    $scope.downloadFile = (url) ->
        confirmPopup = $ionicPopup.confirm(
            title: 'Confirm',
            template: 'Are you sure you want to download this wallpaper?'
            cancelText: 'Cancel'
            okText: 'Save'
        )

        confirmPopup.then (res) ->
            console.log res
            if res
                name = md5.createHash(url) + '.png'
                url = url || ''
                targetPath = ''
                if $rootScope.isIOS
                    targetPath = cordova.file.dataDirectory
                else if $rootScope.isAndroid
                    targetPath = cordova.file.externalApplicationStorageDirectory
                targetPath += name
                options = {}
                trustHosts = yes

                console.warn 'name', name, JSON.stringify name
                console.warn 'targetPath', targetPath

                $ionicLoading.show()

                $cordovaFileTransfer.download(url, targetPath, options, trustHosts).then (result) ->
                    console.warn 'result', result, JSON.stringify result
                    $ionicPopup.alert(
                        title: 'Saved.'
                        okText: 'Ok'
                    )
                    $ionicLoading.hide()
                , (error) ->
                    console.warn 'error', error, JSON.stringify error
                    $ionicPopup.alert(
                        title: 'Can\'t save.'
                        okText: 'Ok'
                    )
                    $ionicLoading.hide()
                , (progress) ->
                    $timeout(->
                        $scope.downloadProgress = (progress.loaded / progress.total) * 100;
                        console.warn 'downloadProgress', $scope.downloadProgress
                    )
            return

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
    