class LiveMain extends Controller then constructor: (
    $ionicHistory, $ionicLoading, $ionicPlatform, $rootScope, $scope, $timeout, GoogleAnalytics, Matches, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'live'

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    matches = new Matches()

    $scope.streaming =
        item: url: null

    $scope.matchEvents = {}

    $scope.matchLabel =
        items: []
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            matches.$getLive({}
            , (success) ->
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
            @loadData(pull: yes)

    $scope.matchLabel.loadData()
    $ionicLoading.show()
