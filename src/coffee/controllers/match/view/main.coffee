class MatchView extends Controller then constructor: (
    $ionicPlatform, $rootScope, $scope, $stateParams, $timeout, GoogleAnalytics, LoadingOverlay, Matches
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
                    LoadingOverlay.hide 'match-view'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'match-view'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'
        getTitle: (matchLabel) ->
            title = ''
            for value, index in matchLabel
                if value.type == 'label'
                    title = value.homeClub.name + ' vs ' + value.awayClub.name
            return title

    $scope.matchLabel.loadData()
    LoadingOverlay.show 'match-view'
