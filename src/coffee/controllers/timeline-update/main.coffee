class TimelineUpdateMain extends Controller then constructor: (
    $ionicHistory, $scope, $timeout, LoadingOverlay
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'timeline-update-timeline'
            LoadingOverlay.hide 'timeline-update-update'
        , 200)
        return
