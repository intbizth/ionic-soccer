class TimelineUpdateMain extends Controller then constructor: (
    $scope, $state, $ionicHistory
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return
