class aboutClubMain extends Controller then constructor: (
    $scope, $state, $ionicHistory
) ->
    $scope.back = ->
#        $ionicHistory.goBack -1
        $state.go 'feature'
        return
