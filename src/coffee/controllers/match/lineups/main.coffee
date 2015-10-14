class MatchLineups extends Controller then constructor: (
    $rootScope, $scope, $stateParams, $ionicLoading, $timeout, Matches, Personals, Und
) ->
    matchId = $stateParams.id || ''

    matchStore = new Matches()

    $scope.lineUp =
        item: {}
        options:
            scope: $scope
            key: 'r'
        loadData: (args) ->
            pull = if !Und.isUndefined(args) and !Und.isUndefined(args.pull) and Und.isBoolean(args.pull) then args.pull else no
            promise = matchStore.find matchId, $scope.lineUp.options
            promise.finally ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $scope.personals.loadData()
            promise.then (model) ->
                $scope.lineUp.item = model.dataTranformToLineUp()
        refresh: ->
            $scope.lineUp.loadData(pull: yes)

    personalStore = new Personals null,
        url: Personals::url + 'club/' + $rootScope.clubId
        state: pageSize: 100

    $scope.personals =
        items: []
        hasMorePage: no
        options:
            scope: $scope
            personalStoreKey: 'personalStore'
            collectionKey: 'personalCollection'
        getPositionClass: (shortName)->
            switch shortName
                when 'GK' then '-goalkeeper'
                when 'DF' then '-defender'
                when 'MF' then '-midfielder'
                when 'FW' then '-forwarder'
                else ''
        loadData: ->
            promise = personalStore.load $scope.personals.options
            promise.finally -> $ionicLoading.hide()
            promise.then ->
                $scope.personals.items = Und.map personalStore.getCollection(), (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.hasMorePage = personalStore.hasMorePage()
        refresh: ->
            options.fetch = yes
            # TODO getFirstPage
            promise = personalStore.getFirstPage $scope.personals.options
            promise.finally ->
                $scope.$broadcast 'scroll.refreshComplete'
            promise.then ->
                $scope.personals.items = Und.map personalStore.getCollection(), (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.hasMorePage = personalStore.hasMorePage()
        loadNext: ->
            personalStore.prepend = yes
            promise = personalStore.getNextPage $scope.personals.options
            promise.finally -> $scope.$broadcast 'scroll.infiniteScrollComplete'
            promise.then ->
                items = personalStore.getCollection().slice 0, personalStore.state.pageSize
                items = Und.map items, (item) ->
                    return item.dataTranformToTeam()
                $scope.personals.items = $scope.personals.items.concat items
                $scope.personals.hasMorePage = personalStore.hasMorePage()

    $scope.lineUp.loadData()

    $ionicLoading.show()
