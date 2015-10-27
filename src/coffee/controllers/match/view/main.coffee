class MatchView extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, $stateParams, $timeout, GoogleAnalytics, Matches, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'view'

    matchId = $stateParams.id || ''

    matchStore = new Matches()

    options =
        scope: $scope
        key: 'r'

    $scope.matchEvents = {}

    $scope.matchLabel =
        items: []
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            if Und.isObject($rootScope.matchView) and Und.size($rootScope.matchView) > 0
                Und.extend $scope.matchEvents, $rootScope.matchView.dataTranformToMatchEvents()
                label = $rootScope.matchView.dataTranformToLive()
                section =
                    type: 'section'
                    startTime: label.startTime
                $scope.matchLabel.items = [section, label]
                $timeout(->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                ,600)
            else
                promise = matchStore.find matchId, options
                promise.finally ->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                promise.then (model) ->
                    $rootScope.matchView = model
                    Und.extend $scope.matchEvents, model.dataTranformToMatchEvents()
                    label = model.dataTranformToView()
                    section =
                        type: 'section'
                        startTime: label.startTime
                    $scope.matchLabel.items = [section, label]
        refresh: ->
            $scope.matchLabel.loadData(pull: yes)

    $scope.matchLabel.loadData()

    $ionicLoading.show()
