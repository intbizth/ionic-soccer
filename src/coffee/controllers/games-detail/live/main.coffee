class GamesDetailLive extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $ionicLoading, $timeout, Matches, Und, Chance
) ->
    $scope.HomeName = 'Chonburi FC'
    $scope.AwayName = 'SCG Muangthong'
    $scope.timeRemain = Und.random(0, 90)
    $scope.StadiumName = 'Chonburi Stadium'

    matchStore = new Matches()

    options =
        url: Matches::url + 'live/'
        scope: $scope
        key: 'r'

    $scope.streaming =
        item:
            url: 'https://www.youtube.com/embed/7bbbvHO69gE'

    $scope.matchEvents = {}

#    $scope.matchLabel =
#        items: []
#        loadData: (args) ->
#            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
#            if Und.isObject($rootScope.live) and Und.size($rootScope.live) > 0
#                $scope.streaming.item.url = $rootScope.live.streaming
#                Und.extend $scope.matchEvents, $rootScope.live.dataTranformToMatchEvents()
#                label = $rootScope.live.dataTranformToLive()
#                section =
#                    type: 'section'
#                    startTime: label.startTime
#                $scope.matchLabel.items = [section, label]
#                $timeout(->
#                    if pull
#                        $scope.$broadcast 'scroll.refreshComplete'
#                    else
#                        $ionicLoading.hide()
#                ,600)
#            else
#                promise = matchStore.find $rootScope.clubId, options
#                promise.finally ->
#                    if pull
#                        $scope.$broadcast 'scroll.refreshComplete'
#                    else
#                        $ionicLoading.hide()
#                promise.then (model) ->
#                    $rootScope.live = model
#                    $scope.streaming.item.url = model.streaming
#                    Und.extend $scope.matchEvents, model.dataTranformToMatchEvents()
#                    label = model.dataTranformToLive()
#                    section =
#                        type: 'section'
#                        startTime: label.startTime
#                    $scope.matchLabel.items = [section, label]
#        refresh: ->
#            $scope.matchLabel.loadData(pull: yes)
#
#    $scope.matchLabel.loadData()

#    $ionicLoading.show()
