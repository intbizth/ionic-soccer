class FanzoneMain extends Controller then constructor: (
    $scope, $state, $ionicHistory
) ->
    $scope.back = ->
        $state.go 'feature'
#        $ionicHistory.goBack -1
        return
