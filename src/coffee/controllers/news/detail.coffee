class NewsDetail extends Controller then constructor: (
    $cordovaInAppBrowser, $ionicHistory, $scope, $stateParams, $timeout, GoogleAnalytics, LoadingOverlay, Papers
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'news-detail'
        , 200)
        return

    $scope.title = ''

    $scope.openURL = (url) ->
        $cordovaInAppBrowser.open(url, '_blank',
            location: 'yes'
            clearcache: 'yes'
            toolbar: 'yes'
        ).then((event) ->
            return
        ).catch (event) ->
            return

    paperId = $stateParams.id || ''
    papers = new Papers()

    $scope.paper =
        item: {}
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            papers.$getId(
                id: paperId
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.item = success
                $scope.title = $this.item.headline
                GoogleAnalytics.trackView 'news-detail ' + $this.item.headline
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'news-detail'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'news-detail'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'

    $scope.paper.loadData()
    LoadingOverlay.show 'news-detail'
