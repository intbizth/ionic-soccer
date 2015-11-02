class aboutClubInfo extends Controller then constructor: (
    $cordovaClipboard, $ionicLoading, $ionicModal, $ionicPlatform, $rootScope, $scope, $timeout, Clubs, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'info'

    clubs = new Clubs()

    $ionicModal.fromTemplateUrl('templates/common/clipboard-modal.html',
        scope: $scope
        animation: 'fade-in'
    ).then((modal) ->
        $scope.modal = modal
        return
    )

    $scope.clipboard = (text) ->
        console.warn typeof text, text
        $cordovaClipboard.copy(text).then(->
            $scope.modal.show()
            $timeout(->
                $scope.modal.hide()
            , 1400)
        , ->

        )

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
