class Update extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, GoogleAnalytics, LoadingOverlay, Papers
) ->
    pageLimit = 20
    papers = new Papers()

    $scope.papers =
        items: []
        next: null
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            papers.$getPage(
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
                    LoadingOverlay.hide 'timeline-update-update'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'timeline-update-update'
            )
        refresh: ->
            if @loaded
                $scope.$broadcast 'scroll.refreshComplete'
            else
                @loadData(flush: yes, pull: yes)
        loadNext: ->
            $this = @
            papers.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.papers.loadData()
    LoadingOverlay.show 'timeline-update-update'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'update'
