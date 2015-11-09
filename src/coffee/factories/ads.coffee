class Ads extends Factory then constructor: (
    $ionicModal, $rootScope, GoogleAnalytics
) ->
    scope = $rootScope.$new()
    scope.banner = './img/ads/banners/1@2x.png'

    $ionicModal.fromTemplateUrl(
        'templates/ads/main.html',
         scope: scope
    ).then (modal) ->
        scope.modal = modal

        scope.openModal = ->
            GoogleAnalytics.trackEvent 'ads', 'show'
            scope.modal.show()
            return
        scope.closeModal = ->
            GoogleAnalytics.trackEvent 'ads', 'hide'
            scope.modal.hide()
            return
        return

    return scope
