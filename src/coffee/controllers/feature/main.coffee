class FeatureMain extends Controller then constructor: (
    $ionicPlatform, $rootScope, $scope, $timeout, Ads, Chance, GoogleAnalytics
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'feature'
        Ads.openModal()
        $timeout(->
            $scope.version = $rootScope.version
        )

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
                id: Chance.integer(min: 1, max: 9999999)
                photo: './img/member/profile@2x.png'
                name: 'Firstname Lastname'
                point1: 0
                point2: 0
            return item

    $scope.profile.loadData()
    $scope.refresh = ->
        $scope.profile.refresh()
        return
