class NewsDetail extends Controller then constructor: (
    $scope, $stateParams, $ionicHistory, $ionicLoading, $cordovaInAppBrowser, Papers, Und
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

    paperId = $stateParams.id ||

    promise = null

    options =
        scope: $scope
        key: 'r'

    $scope.paper =
        item: {}
        loadData: ->
            promise = new Papers().find paperId, options
            promise.finally -> $ionicLoading.hide()
            promise.then (model) -> $scope.paper.item = model.dataTranformToUpdate()
        refresh: ->
            promise = new Papers().find paperId, options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then (model) -> $scope.paper.item = model.dataTranformToUpdate()

    $scope.paper.loadData()

    $ionicLoading.show()
