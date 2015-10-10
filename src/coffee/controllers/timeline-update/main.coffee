class TimelineUpdateMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return
