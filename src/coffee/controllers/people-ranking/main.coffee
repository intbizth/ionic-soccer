class peopleRankingMain extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
#        $ionicHistory.goBack -1
        $state.go 'feature'
        return
