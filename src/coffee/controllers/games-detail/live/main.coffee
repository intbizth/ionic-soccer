class GamesDetailLive extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $ionicLoading, $timeout, GoogleAnalytics, Matches, Und, Chance
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'live'

    $scope.timeRemain = Und.random(0, 90)

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
            if Und.isObject($rootScope.gamesLive) and Und.size($rootScope.gamesLive) > 0
                $scope.streaming.item.url = $rootScope.gamesLive.streaming
                Und.extend $scope.matchEvents, $rootScope.gamesLive.dataTranformToMatchEvents()
                label = $rootScope.gamesLive.dataTranformToLive()
                $scope.matchLabel.items = [label]
                $timeout(->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                ,600)
            else
                promise = matchStore.find $rootScope.clubId, options
                promise.finally ->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                promise.then (model) ->
                    $rootScope.gamesLive = model
                    $scope.streaming.item.url = model.streaming
                    Und.extend $scope.matchEvents, model.dataTranformToMatchEvents()
                    label = model.dataTranformToLive()
                    $scope.matchLabel.items = [label]
        refresh: ->
            $scope.matchLabel.loadData(pull: yes)

    $scope.matchLabel.loadData()

    $ionicLoading.show()

