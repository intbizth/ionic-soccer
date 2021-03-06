class FanzoneWallpapers extends Controller then constructor: (
    $cordovaFile, $cordovaFileTransfer, $ionicPlatform, $ionicPopup, $rootScope, $scope, $timeout, $translate, GoogleAnalytics, LoadingOverlay, Images, Wallpapers
) ->
    $scope.translate =
        download:
            title: '',
            template: ''
            cancelText: ''
            okText: ''
        popup:
            title: ''
            okText: ''

    $scope.downloadFile = (url) ->
        confirmPopup = $ionicPopup.confirm $scope.translate.download

        confirmPopup.then (res) ->
            if res
                options = $scope.translate.popup
                LoadingOverlay.show 'fanzone-wallpapers'
                Images.saveToLibrary(url
                , ->
                    $ionicPopup.alert options
                    LoadingOverlay.hide 'fanzone-wallpapers'
                , (error) ->
                    options.title = error
                    $ionicPopup.alert options
                    LoadingOverlay.hide 'fanzone-wallpapers'
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
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            wallpapers.$getPage(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'fanzone-wallpapers'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'fanzone-wallpapers'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
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
    LoadingOverlay.show 'fanzone-wallpapers'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'wallpapers'

    $translate(
        [
            'fanzone.wallpapers.download.title'
            'fanzone.wallpapers.download.detail'
            'fanzone.wallpapers.download.cancel'
            'fanzone.wallpapers.download.ok'
            'fanzone.wallpapers.popup.title'
            'fanzone.wallpapers.popup.ok'
        ]
    ).then((translations) ->
        $scope.translate.download.title = translations['fanzone.wallpapers.download.title']
        $scope.translate.download.template = translations['fanzone.wallpapers.download.detail']
        $scope.translate.download.cancelText = translations['fanzone.wallpapers.download.cancel']
        $scope.translate.download.okText = translations['fanzone.wallpapers.download.ok']
        $scope.translate.popup.title = translations['fanzone.wallpapers.popup.title']
        $scope.translate.popup.okText = translations['fanzone.wallpapers.popup.ok']
    )
