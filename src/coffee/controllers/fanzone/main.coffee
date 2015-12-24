class FanzoneMain extends Controller then constructor: (
    $ionicHistory, $scope, $timeout, LoadingOverlay
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'fanzone-products'
            LoadingOverlay.hide 'fanzone-wallpapers'
        , 400)
        return
