class LiveMain extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $ionicPlatform, $rootScope, $scope, GoogleAnalytics, Matches
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    matches = new Matches()

    $scope.streaming =
        item: url: null

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
                $scope.streaming.item.url = success.streaming
                $this.items = success.matchLabel
                $scope.matchEvents = success.matchEvents
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
