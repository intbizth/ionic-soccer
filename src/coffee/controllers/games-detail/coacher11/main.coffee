class GamesDetailCoacher11 extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, $timeout, GoogleAnalytics, Matches, Und, Chance
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'games_coacher11'

    $scope.timeRemain = Und.random(0, 90)

    matchStore = new Matches()

    options =
        url: Matches::url + 'live/'
        scope: $scope
        key: 'r'

    $scope.matchLabel =
        items: []
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            if Und.isObject($rootScope.gamesLive) and Und.size($rootScope.gamesLive) > 0
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
                    label = model.dataTranformToLive()
                    $scope.matchLabel.items = [label]
        refresh: ->
            $scope.matchLabel.loadData(pull: yes)

    $scope.matchLabel.loadData()

    $ionicLoading.show()
