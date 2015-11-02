class aboutClubInfo extends Controller then constructor: (
    $ionicLoading, $ionicPlatform, $rootScope, $scope, $timeout, Clubs, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'info'

    clubs = new Clubs()

    $scope.club =
        item: {}
        loadData: (args)->
            $this = @
            pull = if args && args.pull then args.pull else no
            clubs.$getMe({}
            , (success) ->
                $this.item = success
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

    $scope.club.loadData()
    $ionicLoading.show()
