class MatchView extends Controller then constructor: (
    $rootScope, $scope, $stateParams, $ionicHistory, $ionicLoading, Matches, Und
) ->
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
