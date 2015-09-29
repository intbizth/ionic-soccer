class GamesMain extends Controller then constructor: (
    $scope, $ionicPlatform, $ionicHistory, $sce, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.title = 'Games'
