class GamesDetailMain extends Controller then constructor: (
    $scope, $ionicPlatform, $ionicHistory, $sce, $timeout, Und, Chance
) ->
    $scope.navBarTitle =
        titleName: "เกมทายผล"
        setTitle: (title) ->
            this.titleName = title
            return

    $scope.isIOS = ionic.Platform.isIOS()

    $scope.back = ->
        $ionicHistory.goBack -1
        return
