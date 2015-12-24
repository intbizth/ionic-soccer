class CompetitionTableMain extends Controller then constructor: (
    $ionicHistory, $scope, $timeout, LoadingOverlay
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'competition-table-fixture'
            LoadingOverlay.hide 'competition-table-results'
            LoadingOverlay.hide 'competition-table-position-table'
        , 200)
        return
