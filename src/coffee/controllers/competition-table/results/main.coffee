class CompetitionTableResult extends Controller then constructor: (
    $ionicPlatform, $rootScope, $scope, GoogleAnalytics, LoadingOverlay, Matches
) ->
    pageLimit = 20
    matches = new Matches()

    $scope.matchLabel =
        items: []
        next: null
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            matches.$getResults(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'competition-table-results'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'competition-table-results'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
        loadNext: ->
            $this = @
            matches.$getResults(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.matchLabel.loadData()
    LoadingOverlay.show 'competition-table-results'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'results'
