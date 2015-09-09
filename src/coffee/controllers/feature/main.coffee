class FeatureMain extends Controller then constructor: (
        $scope, $state
) ->
    $scope.back = ->
        $state.go 'ads-main'

    $scope.goLive = ->
        $state.go 'live-main'

    $scope.fullname = 'Jackson Matinez'
    $scope.point1 = 9999999
    $scope.point2 = 9999999
