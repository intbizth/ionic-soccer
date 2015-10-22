class FeatureMain extends Controller then constructor: (
    $scope, $ionicModal, $cordovaAppVersion, $timeout, Und, Chance, $cordovaGoogleAnalytics, $ionicPlatform
) ->
#    $cordovaGoogleAnalytics.debugMode();
#    $cordovaGoogleAnalytics.startTrackerWithId('UA-69117679-1');
#    $cordovaGoogleAnalytics.trackView('Feature');

#    $ionicPlatform.reasdy ->
#        if typeof $cordovaGoogleAnalytics != undefined
#            $cordovaGoogleAnalytics.startTrackerWithId('UA-69117679-1')
#        else
#            console.log "Google Analytics Unavailable"

    $cordovaGoogleAnalytics.trackView('Screen Title')

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
        $scope.modal.show()
        return
    $scope.closeAds = ->
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
