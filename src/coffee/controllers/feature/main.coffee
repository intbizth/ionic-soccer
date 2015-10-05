class FeatureMain extends Controller then constructor: (
    $scope, $ionicModal, $cordovaAppVersion, $timeout, Und, Chance
) ->
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
                photo: profile.image.src
                name: profile.name
                point1: Und.random(1, 9999999999)
                point2: Und.random(1, 9999999999)
            return item

    $scope.profile.loadData()

    $scope.refresh = ->
        $scope.profile.refresh()
        return
