class GamesDetailMain extends Controller then constructor: (
    $scope, $ionicPlatform, $ionicHistory, $sce, $timeout, Und, Chance
) ->
    $scope.isIOS = ionic.Platform.isIOS()
    $scope.back = ->
        $ionicHistory.goBack -1
        return
