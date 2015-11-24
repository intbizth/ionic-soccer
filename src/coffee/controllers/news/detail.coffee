class NewsDetail extends Controller then constructor: (
    $cordovaInAppBrowser, $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Papers
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.title = ''

    $scope.openURL = (url) ->
        $cordovaInAppBrowser.open(url, '_blank',
            location: 'yes'
            clearcache: 'yes'
            toolbar: 'yes'
        ).then((event) ->
            # success
            return
        ).catch (event) ->
            # error
            return

    paperId = $stateParams.id || ''
    papers = new Papers()

    $scope.paper =
        item: {}
        loaded: no
        loadData: (args) ->
            $this = @
            $this.loaded = no
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
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
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.paper.loadData()
    $ionicLoading.show()
