class MatchLineups extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, $stateParams, $timeout, GoogleAnalytics, Matches, Personals, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'lineups'

    matchId = $stateParams.id || ''
    matches = new Matches()

    $scope.lineUp =
        item: {}
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            matches.$getLineUp(id: matchId
            , (success) ->
                $this.item = success
                $this.item.club = $this.item[$this.item.me]
                $scope.personals.loadData(pull: pull)
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(pull: yes)

    pageLimit = 100
    personals = new Personals()

    $scope.personals =
        items: []
        next: no
        getPositionClass: (shortName)->
            switch shortName
                when 'GK' then '-goalkeeper'
                when 'DF' then '-defender'
                when 'MF' then '-midfielder'
                when 'FW' then '-forwarder'
                else ''
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            personals.$getClubMe(
                page: 1
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(pull: yes)
        loadNext: ->
            $this = @
            personals.$getClubMe(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.lineUp.loadData()
    $ionicLoading.show()
