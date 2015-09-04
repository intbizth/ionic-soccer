class Ads extends Controller then constructor: (
    $scope, $state
) ->
    $scope.close = ->
        $state.go 'feature'
