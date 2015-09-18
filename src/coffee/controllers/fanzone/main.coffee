class FanzoneMain extends Controller then constructor: (
    $scope, $state, $ionicHistory
) ->
    $scope.back = ->
        $state.go 'feature'
        return
