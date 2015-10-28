class NewsDetail extends Controller then constructor: (
    $cordovaInAppBrowser, $ionicHistory, $ionicLoading, $scope, $stateParams, GoogleAnalytics, Papers, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

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
        loadData: (args) ->
            pull = if args && args.pull then args.pull else no
            papers.getId(paperId
            , (success) ->
                $scope.paper.item = papers.dataTranformToDetail(success)
                GoogleAnalytics.trackView 'news-detail ' + $scope.paper.item.headline
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

            if pull
                $scope.$broadcast 'scroll.refreshComplete'
            else
                $ionicLoading.hide()
        refresh: ->
            $scope.paper.loadData(pull: yes)

    $scope.paper.loadData()
    $ionicLoading.show()
