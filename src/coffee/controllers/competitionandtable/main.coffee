class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $state
) ->
    $scope.back = ->
        $state.go 'feature-main'
        return

    $scope.isLive = true
