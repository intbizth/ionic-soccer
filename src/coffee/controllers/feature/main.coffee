class FeatureMain extends Controller then constructor: (
    $scope, $state, $ionicPopover
) ->
    $ionicPopover.fromTemplateUrl(
        'templates/feature/ads.html',
         scope: $scope
    ).then (modal) ->
        $scope.modal = modal
        return

    $scope.openAds = ->
        console.log 'openAds'
        $scope.modal.show()
        return

    $scope.closeAds = ->
        console.log 'closeAds'
        $scope.modal.hide()
        return

    $scope.fullname = 'Jackson Matinez'
    $scope.point1 = 9999999
    $scope.point2 = 9999999
