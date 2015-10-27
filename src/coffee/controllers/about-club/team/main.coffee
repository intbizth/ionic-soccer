class aboutClubTeam extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, GoogleAnalytics, Personals, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'team'

    $scope.headline = 'CHALARMCHON'

    personalStore = new Personals null,
        url: Personals::url + 'club/' + $rootScope.clubId
        state: pageSize: 100

    options =
        scope: $scope
        personalStoreKey: 'personalStore'
        collectionKey: 'personalCollection'

    $scope.personals =
        items: []
        hasMorePage: no
        getPositionClass: (shortName)->
            switch shortName
                when 'GK' then '-goalkeeper'
                when 'DF' then '-defender'
                when 'MF' then '-midfielder'
                when 'FW' then '-forwarder'
                else ''
        loadData: ->
            promise = personalStore.load options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.personals.items = Und.map personalStore.getCollection(), (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.hasMorePage = personalStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = personalStore.getFirstPage options
            promise.finally -> $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.personals.items = Und.map personalStore.getCollection(), (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.hasMorePage = personalStore.hasMorePage()
        loadNext: ->
            personalStore.prepend = yes
            promise = personalStore.getNextPage options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = personalStore.getCollection().slice 0, personalStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.items = $scope.personals.items.concat items
                $scope.personals.hasMorePage = personalStore.hasMorePage()

    $scope.personals.loadData()

    $ionicLoading.show()
