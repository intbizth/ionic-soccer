class FanzoneWallpapers extends Controller then constructor: (
    $cordovaFile, $cordovaFileTransfer, $ionicLoading, $ionicPlatform, $ionicPopup, $rootScope, $scope, $timeout, GoogleAnalytics, Images, Und, Wallpapers
) ->
    $scope.downloadFile = (url) ->
        confirmPopup = $ionicPopup.confirm(
            title: 'Download',
            template: 'Are you sure you want to download this wallpaper?'
            cancelText: 'Cancel'
            okText: 'Save'
        )

        confirmPopup.then (res) ->
            if res
                $ionicLoading.show()
                Images.saveToLibrary(url
                , ->
                    message = ''
                    if $rootScope.isIOS
                        message = 'Saved to camera roll.'
                    else if $rootScope.isAndroid
                        message = 'Saved'
                    $ionicPopup.alert(
                        title: message
                        okText: 'Ok'
                    )
                    $ionicLoading.hide()
                , (error) ->
                    $ionicPopup.alert(
                        title: error
                        okText: 'Ok'
                    )
                    $ionicLoading.hide()
                )
            return

    pageLimit = 20
    wallpapers = new Wallpapers()

    $scope.wallpapers =
        items: []
        next: null
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            wallpapers.$getPage(
                page: 1
                limit: pageLimit
            , (success) ->
                $this.loaded = yes
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

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'wallpapers'
