class MatchMain extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $timeout
) ->
    $scope.title = ''

    $scope.back = ->
        $timeout(->
            $rootScope.matchTitle = ''
        , 200)
        $ionicHistory.goBack -1
        return

    $rootScope.$watch(->
        return $rootScope.matchTitle
    , (value) ->
        $scope.title = value
    )
