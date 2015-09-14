class competitionAndTableMain extends Controller then constructor: (
    $scope, $state
) ->
    $scope.back = ->
        $state.go 'feature-main'
        return

    $scope.fullname = 'name - name'
