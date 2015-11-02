class FanzoneWallpapers extends Controller then constructor: (
    $cordovaFileTransfer, $ionicLoading, $ionicPlatform, $ionicPopup, $rootScope, $scope, $timeout, GoogleAnalytics, md5, Und, Wallpapers
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'wallpapers'

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

    pageLimit = 20
    wallpapers = new Wallpapers()

    $scope.wallpapers =
        items: []
        next: null
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            wallpapers.$getPage(
                page: 1
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(pull: yes)
        loadNext: ->
            $this = @
            wallpapers.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.wallpapers.loadData()
    $ionicLoading.show()
