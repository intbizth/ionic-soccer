class FeatureMain extends Controller then constructor: (
    $scope, $ionicHistory, $ionicModal, $timeout, $cordovaAppVersion
) ->
    $ionicModal.fromTemplateUrl(
        'templates/feature/ads.html',
         scope: $scope
         animation: 'no-animation'
    ).then (modal) ->
        $scope.modal = modal

        $timeout (->
            $scope.openAds()
            return
        ), 100
        return

    $scope.openAds = ->
        $scope.modal.show()
        return

    $scope.closeAds = ->
        $scope.modal.hide()
        return

    $scope.fullname = 'Jackson Matinez'
    $scope.point1 = 9999999
    $scope.point2 = 9999999

    $scope.version = '0.0.0'

    document.addEventListener('deviceready', ->
        $cordovaAppVersion.getVersionNumber().then ((version) ->
            $scope.version = version
            return
        )
        return
    , false)
