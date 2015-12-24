class CompetitionTablePositionTable extends Controller then constructor: (
    $ionicPlatform, $rootScope, $scope, GoogleAnalytics, LoadingOverlay, Standings
) ->
    competitionCode = 'tpl'
    pageLimit = 50
    standings = new Standings()

    $scope.position =
        items: []
        next: null
        loaded: no
        no: null
        season: null
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            standings.$getPositionTable(
                competitionCode: competitionCode
                pageLimit: pageLimit
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if success.items.length > 0
                    $this.season = success.items[0].season
                for value, index in success.items
                    if value.me
                        $this.no = value.overallPosition
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'competition-table-position-table'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'competition-table-position-table'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
        loadNext: ->
            $this = @
            standings.$getPositionTable(
                page: $this.next
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                for value, index in success.items
                    if value.me
                        $this.no = value.overallPosition
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.position.loadData()
    LoadingOverlay.show 'competition-table-position-table'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'position-table'
