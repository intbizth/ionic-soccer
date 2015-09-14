class liveMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.headline = "Live"
    $scope.dateTop = "Sep 2015"
    $scope.dateMatch = "1 Sep 2015"
    $scope.score = "1 - 1"
    $scope.teamName1 = "Chonburi FC"
    $scope.teamName2 = "Suphanburi FC"
    $scope.playerName1 = "K. Thawikan"
    $scope.playerName2 = "C. Chappuis"
    $scope.playerName3 = "J. Mineiro"
    $scope.playerName4 = " J. Pulek"