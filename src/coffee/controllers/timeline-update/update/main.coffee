class Update extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, GoogleAnalytics, Papers
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'update'

    pageLimit = 20
    papers = new Papers()

    $scope.papers =
        items: []
        next: null
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            papers.$getPage(
                page: 1
                limit: pageLimit
                flush: flush
            , (success) ->
                console.warn success
                $this.next = if success.next then success.next else null
                $this.items = success.items
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            , (error) ->
                console.warn error
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    $ionicLoading.hide()
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)
        loadNext: ->
            $this = @
            papers.$getPage(
                page: $this.next
                limit: pageLimit
            , (success) ->
                console.warn success
                $this.next = if success.next then success.next else null
                $this.items = $this.items.concat success.items
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            , (error) ->
                console.warn error
                $scope.$broadcast 'scroll.infiniteScrollComplete'
            )

    $scope.papers.loadData()
    $ionicLoading.show()
