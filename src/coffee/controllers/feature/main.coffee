class FeatureMain extends Controller then constructor: (
    $cordovaAppVersion, $ionicModal, $ionicPlatform, $scope, $timeout, Chance, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'feature'

    $scope.ads =
        item: './img/ads/banners/1@2x.png'

    $ionicModal.fromTemplateUrl(
        'templates/feature/ads.html',
         scope: $scope
    ).then (modal) ->
        $scope.modal = modal

        $timeout (->
            $scope.openAds()
            return
        )
        return
    $scope.openAds = ->
        GoogleAnalytics.trackEvent 'ads', 'show'
        $scope.modal.show()
        return
    $scope.closeAds = ->
        GoogleAnalytics.trackEvent 'ads', 'hide'
        $scope.modal.hide()
        return
    $scope.version = '0.0.0'
    document.addEventListener('deviceready', ->
        $cordovaAppVersion.getVersionNumber().then ((version) ->
            $scope.version = version
            return
        )
        return
    , false)
    $scope.profile =
        item: {},
        loadData: ->
            @item = @fakeItem()
            console.log('profile:loadData', JSON.stringify(@item))
            return
        refresh: ->
            console.log 'profile:doRefresh'
            $this = @
            $timeout(->
                console.log 'profile:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                id: Und.random(1, 9999999)
                photo: './img/feature/profile@2x.png'
                name: 'Firstname Lastname'
                point1: 0
                point2: 0
            return item

    $scope.profile.loadData()

    $scope.refresh = ->
        $scope.profile.refresh()
        return
