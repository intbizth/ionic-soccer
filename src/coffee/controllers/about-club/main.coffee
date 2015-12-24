class AboutClubMain extends Controller then constructor: (
    $ionicHistory, $scope, $timeout, LoadingOverlay
) ->
    $scope.back = ->
    # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'about-club-info'
            LoadingOverlay.hide 'about-club-team'
        , 200)
        return
