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

    paperId = $stateParams.id || ''
    paperStore = new Papers()
    options =
        scope: $scope
        key: 'r'

    $scope.paper =
        item: {}
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            promise = paperStore.find paperId, options
            promise.finally ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            promise.then (model) -> $scope.paper.item = model.dataTranformToUpdate()
        refresh: ->
            $scope.paper.loadData(pull: true)

    $scope.paper.loadData()

    $ionicLoading.show()
