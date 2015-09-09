class competitionAndTableMain extends Controller then constructor: (
    $scope, $state
) ->
    $scope.back = ->
        $state.go 'feature-main'
        return

    $scope.items = [
        { id: 0 },
        { id: 1 },
        { id: 2 },
        { id: 3 },
        { id: 4 }
    ]
