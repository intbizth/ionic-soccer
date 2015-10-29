class MatchView extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, $stateParams, $timeout, GoogleAnalytics, Matches, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'view'

    matchId = $stateParams.id || ''
    matches = new Matches()

    $scope.matchEvents = {}

    $scope.matchLabel =
        items: []
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            matches.$getId(id: matchId
            , (success) ->
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
