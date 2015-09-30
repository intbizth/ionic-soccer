class FeatureMain extends Controller then constructor: (
    $scope, $ionicHistory, $ionicModal, $cordovaAppVersion, $timeout, Und, Chance
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
            item = this.fakeItem()
            this.item =  item
            console.log('profile:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'profile:doRefresh'
            $this = this
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
    $scope.doRefresh = ->
        $scope.profile.doRefresh()
        return
