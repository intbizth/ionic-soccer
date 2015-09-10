class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $state
) ->
    $scope.isLive = true
    $scope.timelines = []

    i = 0
    while i < 10
        timeline = a: 'test'
        $scope.timelines.push timeline
        i++
