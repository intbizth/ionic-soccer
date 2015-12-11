class LiveMain extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $ionicPlatform, $rootScope, $sce, $scope, GoogleAnalytics, Matches, Settings
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    matches = new Matches()
    settings = new Settings()

    $scope.streaming =
        item: {}
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            settings.$get(
                flush: flush
            , (success) ->
                $this.loaded = yes
                if success.matchLiveStreaming
                    $this.item.url = $sce.trustAsResourceUrl success.matchLiveStreaming
            , (error) ->
                return
            )

    $scope.matchEvents = {}

    $scope.matchLabel =
        items: []
        loaded: no
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            matches.$getLive(
                flush: flush
            , (success) ->
                $this.loaded = yes
                if success.matchLabel and success.matchEvents
                    $this.items = success.matchLabel
                    $scope.matchEvents = success.matchEvents
                    $scope.streaming.loadData(flush: flush, pull: pull)
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
            @loadData(flush: yes, pull: yes)

    $scope.matchLabel.loadData()
    $ionicLoading.show()

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'live'
