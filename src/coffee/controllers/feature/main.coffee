class FeatureMain extends Controller then constructor: (
    $filter, $ionicHistory, $ionicPlatform, $rootScope, $scope, $state, $translate, $timeout, Ads, Authen, AuthenUI, GoogleAnalytics
) ->
    $scope.version = $rootScope.version

    $ionicHistory.clearHistory()
    $ionicHistory.clearCache()

    $scope.isLoggedin = $rootScope.isLoggedin
    $scope.translate =
        login: ''
        logout: ''

    $scope.changePicture = ->
        if $scope.isLoggedin and $rootScope.user
            $state.go 'member-picture'

    $scope.profile =
        item: {}
        pictureLoaded: no
        itemDefault:
            id: 0
            picture: './img/member/picture@2x.png'
            name: 'guest'
            point1: 0
            point2: 0
        setDefault: ->
            @pictureLoaded = no
            @item = angular.copy @itemDefault
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            promise = Authen.getUser(flush: flush)
            promise.then((success) ->
                $this.item.id = success.id
                $this.item.name = success.firstName + ' ' + success.lastName
                if success.profilePicture
                    $scope.media.state = 'load'
                    $this.pictureLoaded = yes
                    $this.item.picture = success.profilePicture
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
            , (error) ->
                $scope.media.state = 'blank'
                $this.setDefault()
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.media =
        state: 'blank'

    $scope.profile.setDefault()
    $scope.profile.loadData()

    $scope.login = ->
        $rootScope.$emit 'event:auth-loginRequired'

    $scope.logout = ->
        $rootScope.$emit 'event:auth-logout'

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $scope.isLoggedin = data
        $scope.profile.loadData()

    $rootScope.$on 'profile:pictureChange', (event, data) ->
        if data is null
            $scope.media.state = 'blank'
            $scope.profile.item.picture = $scope.profile.itemDefault.picture
        else
            $scope.media.state = 'new'
            $scope.profile.item.picture = data

        $rootScope.user.profilePicture = data

    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'feature'

    $rootScope.$on 'version', (event, data) ->
        $scope.version = data

    Ads.$on 'ready', ->
        Ads.openModal()

    $translate(
        [
            'member.display.guest'
            'member.display.loading'
            'member.button.login'
            'member.button.logout'
        ]
    ).then((translations) ->
        $scope.translate.login = translations['member.button.login']
        $scope.translate.logout = translations['member.button.logout']
        $scope.profile.itemDefault.name = translations['member.display.guest']
        $scope.profile.item.name = if $scope.isLoggedin then translations['member.display.loading'] else translations['member.display.guest']
    )
