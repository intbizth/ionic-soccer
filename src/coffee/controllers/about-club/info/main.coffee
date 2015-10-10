class aboutClubInfo extends Controller then constructor: (
    $rootScope, $scope, $ionicLoading, $timeout, Clubs, Und
) ->
    clubId = 28

    clubStore = new Clubs()

    options =
        scope: $scope
        key: 'r'

    $scope.club =
        item: {}
        loadData: (args)->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            if Und.isObject($rootScope.club) and Und.size($rootScope.club) > 0
                $scope.club.item = $rootScope.club
                $timeout(->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                ,600)
            else
                promise = clubStore.find clubId, options
                promise.finally ->
                    if pull
                        $scope.$broadcast 'scroll.refreshComplete'
                    else
                        $ionicLoading.hide()
                promise.then (model) -> $rootScope.club = $scope.club.item = model.dataTranformToInfo()
        refresh: ->
            $scope.club.loadData(pull: yes)

    $scope.club.loadData()

    $ionicLoading.show()
