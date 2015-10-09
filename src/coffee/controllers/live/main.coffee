class LiveMain extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $ionicLoading, $timeout, Matches, Und
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    clubId = 28
    matchStore = new Matches()
    options =
        url: Matches::url + 'live/'
        scope: $scope
        key: 'r'

    $scope.streaming =
        item: url: null

    $scope.matchEvents = {}

    $scope.matchLabel =
        items: []
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            if Und.isObject($rootScope.live) and Und.size($rootScope.live) > 0
                $scope.streaming.item.url = $rootScope.live.streaming
                Und.extend $scope.matchEvents, $rootScope.live.dataTranformToMatchEvents()
                $scope.matchLabel.items = [$rootScope.live.dataTranformToLive()]
                $timeout(->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                ,600)
            else
                promise = matchStore.find clubId, options
                promise.finally ->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                promise.then (model) ->
                    $rootScope.live = model
                    $scope.streaming.item.url = model.streaming
                    Und.extend $scope.matchEvents, model.dataTranformToMatchEvents()
                    $scope.matchLabel.items = [model.dataTranformToLive()]
        refresh: ->
            $scope.matchLabel.loadData(pull: yes)

    $scope.matchLabel.loadData()

    $ionicLoading.show()

    $scope.refresh = ->
        $scope.matchLabel.refresh()
