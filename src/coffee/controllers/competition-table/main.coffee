class CompetitionTableMain extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return
