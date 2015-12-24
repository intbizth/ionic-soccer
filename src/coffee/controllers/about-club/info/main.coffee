class aboutClubInfo extends Controller then constructor: (
    $cordovaClipboard, $cordovaVibration, $ionicModal, $ionicPlatform, $rootScope, $scope, $timeout, Clubs, GoogleAnalytics, LoadingOverlay
) ->
    clubs = new Clubs()

    $scope.clipboard = (text) ->
        $cordovaClipboard.copy(text).then((success) ->
            $scope.modal.show()
            $cordovaVibration.vibrate 300
            $timeout(->
                $scope.modal.hide()
            , 1400)
        , (error) ->
            return
        )

    $scope.club =
        item: {}
        loaded: no
        loadData: (args)->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            if !pull
                $this.loaded = no
            clubs.$getMe(
                flush: flush
            , (success) ->
                $this.loaded = yes
                $this.item = success
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'about-club-info'
            , (error) ->
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
                else
                    LoadingOverlay.hide 'about-club-info'
            )
        refresh: ->
            if @loaded
                @loadData(flush: yes, pull: yes)
            else
                $scope.$broadcast 'scroll.refreshComplete'

    $scope.club.loadData()
    LoadingOverlay.show 'about-club-info'

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'info'

    $ionicModal.fromTemplateUrl('templates/common/clipboard-modal.html',
        scope: $scope
        animation: 'fade-in'
    ).then((modal) ->
        $scope.modal = modal
        return
    )
