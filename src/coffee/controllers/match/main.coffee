class MatchMain extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $timeout, LoadingOverlay
) ->
    $scope.title = ''

    $scope.back = ->
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'match-view'
            $rootScope.matchTitle = ''
        , 200)
        return

    $rootScope.$watch(->
        return $rootScope.matchTitle
    , (value) ->
        $scope.title = value
    )
