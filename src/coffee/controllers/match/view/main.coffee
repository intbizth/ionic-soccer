class MatchView extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, $stateParams, $timeout, GoogleAnalytics, Matches
) ->
    matchId = $stateParams.id || ''
    matches = new Matches()

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
            matches.$getId(
                id: matchId
            , (success) ->
                $this.loaded = yes
                $this.items = success.matchLabel
                $scope.matchEvents = success.matchEvents
                $rootScope.matchTitle = $this.getTitle success.matchLabel
                GoogleAnalytics.trackView $rootScope.matchTitle
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
        getTitle: (matchLabel) ->
            title = ''
            angular.forEach matchLabel, (value, key) ->
                if value.type == 'label'
                    title = value.homeClub.name + ' vs ' + value.awayClub.name
            return title

    $scope.matchLabel.loadData()
    $ionicLoading.show()
