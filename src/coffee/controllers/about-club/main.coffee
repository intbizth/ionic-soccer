class aboutClubMain extends Controller then constructor: (
    $scope, $state, $ionicHistory
) ->
    $scope.back = ->
        $state.go 'timeline-update.main'
