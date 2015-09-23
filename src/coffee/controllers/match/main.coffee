class MatchMain extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $state.go 'competition-table.main'
        return
