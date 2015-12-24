class aboutClubTeam extends Controller then constructor: (
    $ionicPlatform, $rootScope, $scope, GoogleAnalytics, LoadingOverlay, Personals
) ->
    pageLimit = 100
    personals = new Personals()

    $scope.headline = 'CHALARMCHON'

    $scope.personals =
        items: []
        next: no
        loaded: no
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
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            personals.$getClubMe(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'about-club-team'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'about-club-team'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
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

    $scope.personals.loadData()
    LoadingOverlay.show 'about-club-team'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'team'
