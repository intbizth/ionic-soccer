class FeatureMain extends Controller then constructor: (
    $document, $ionicHistory, $ionicPlatform, $rootScope, $scope, $timeout, Ads, Authen, GoogleAnalytics
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'feature'

    $scope.version = $rootScope.version
    $rootScope.$on 'version', (event, data) ->
        $scope.version = data

    Ads.$on 'ready', ->
        Ads.openModal()

    $ionicHistory.clearHistory()
    $ionicHistory.clearCache()

    $scope.isLoggedin = $rootScope.isLoggedin

    $scope.profile =
        item: {}
        photo:
            element: angular.element $document[0].querySelector '.profile img.photo'
            setDefault: ->
                @element.attr 'src', './img/member/photo.png'
                @element.attr 'srcset', './img/member/photo@2x.png 2x'
            setData: (data) ->
                @element.attr 'src', data
                @element.removeAttr 'srcset'
        setDefault: ->
            @item =
                id: 0
                name: 'Guest'
                point1: 0
                point2: 0
            @photo.setDefault()
        loadData: (args) ->
            $this = @
            pull = if args && args.pull then args.pull else no
            flush = if args && args.flush then args.flush else no
            promise = Authen.getUser(flush: flush)
            promise.then((success) ->
                $this.item =
                    id: success.id
                    name: success.firstname + ' ' + success.lastname
                    point1: 0
                    point2: 0
                if success.profilePicture
                    $this.photo.setData success.profilePicture
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
            , (error) ->
                $this.setDefault()
                if pull
                    $scope.$broadcast 'scroll.refreshComplete'
            )
        refresh: ->
            @loadData(flush: yes, pull: yes)

    $scope.profile.setDefault()
    $scope.profile.loadData()

    $scope.login = ->
        $rootScope.$emit 'event:auth-loginRequired'

    $scope.logout = ->
        $rootScope.$emit 'event:auth-logout'

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $scope.isLoggedin = data
        $scope.profile.loadData()
        return
