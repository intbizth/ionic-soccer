class LiveMain extends Controller then constructor: (
    $ionicHistory, $ionicPlatform, $rootScope, $sce, $scope, $timeout, GoogleAnalytics, LoadingOverlay, Matches, Settings
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'live'
        , 200)
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
                    LoadingOverlay.hide 'live'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'live'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'

    $scope.matchLabel.loadData()
    LoadingOverlay.show 'live'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'live'
