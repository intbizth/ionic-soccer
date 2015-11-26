class aboutClubInfo extends Controller then constructor: (
    $cordovaClipboard, $ionicLoading, $ionicModal, $ionicPlatform, $rootScope, $scope, $timeout, Clubs, GoogleAnalytics
) ->
    clubs = new Clubs()

    $scope.clipboard = (text) ->
        $cordovaClipboard.copy(text).then((success) ->
            $scope.modal.show()
            $timeout(->
                $scope.modal.hide()
            , 1400)
        , (error) ->

        )

    $scope.club =
        item: {}
        loaded: no
        loadData: (args)->
            $this = @
            pull = if args && args.pull then args.pull else no
            clubs.$getMe({}
            , (success) ->
                $this.loaded = yes
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

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'info'

    $ionicModal.fromTemplateUrl('templates/common/clipboard-modal.html',
        scope: $scope
        animation: 'fade-in'
    ).then((modal) ->
        $scope.modal = modal
        return
    )
