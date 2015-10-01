class TimelineUpdateMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->
    $scope.isIOS = ionic.Platform.isIOS()
    $scope.back = ->
        $ionicHistory.goBack -1
        return
