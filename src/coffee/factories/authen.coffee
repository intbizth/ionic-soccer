class Authen extends Factory then constructor: (
    $ionicLoading, $ionicModal, $q, $rootScope, $sessionStorage, $state, authService, OAuth, OAuthToken, Users
) ->
#    _modal = null
#    _stateTo = null
#    _stateFrom = null
#    _dialogTemplate = null

    reset = ->
        delete $sessionStorage.user
        OAuthToken.removeToken()

    getUser = (args) ->
        flush = if args && args.flush then args.flush else no
        users = new Users()
        users.$info(
            flush: flush
        , (success) ->
            console.warn '$info:success', success
            $sessionStorage.user = success
#            authService.loginConfirmed $sessionStorage.user, (config) ->
#                return config
        , (error) ->
            console.warn '$info:error', error
            somethingWrong error
        )

    somethingWrong = (error) ->
        reset()
        if error.status == 400 then message = error.error_description
        else if error.status == 500 then message = error.statusText
        else message = ''

    login = (username, password) ->
        return $q((resolve, reject) ->
            OAuth.getAccessToken({
                username: username
                password: password
            }).then((success) ->
                console.warn 'OAuth.getAccessToken:success', success
                resolve getUser(flush: yes)
            , (error) ->
                console.error 'OAuth.getAccessToken:error', error
                reject somethingWrong error
            )
        )

    logout = (rejection) ->
        reset()
        $rootScope.$broadcast('event:auth-logout', rejection)
        return

    isLoggedin = OAuth.isAuthenticated()

    ui =
        login: ->
            scope = $rootScope.$new()
            scope.data =
                isPass: no
                username: ''
                password: ''
                fake: ->
                    $this = @
                    users = new Users()
                    users.$testgetlogin({}
                    , (success) ->
                        console.warn '$testlogin:success', success
                        $this.username = success.username
                        $this.password = success.password
                        $this.valid()
                    , (error) ->
                        console.error '$testlogin:error', error
                    )
                reset: ->
                    @username = @password = ''
                    @valid()
                valid: ->
                    pass = yes
                    if not @username?.length
                        pass = no
                    if not @password?.length
                        pass = no
                    @isPass = pass
                submit: ->
                    data =
                        username: @username
                        password: @password

                    $ionicLoading.show()

                    promise = login data.username, data.password
                    promise.then(->
                        console.warn 'Authen.login:success'
                        $ionicLoading.hide()
                        scope.modal.hide()
                    , ->
                        console.error 'Authen.login:error'
                        $ionicLoading.hide()
                    )
            $ionicModal.fromTemplateUrl(
                'templates/authen/login.html',
                scope: scope
            ).then (modal) ->
                scope.modal = modal
                scope.modal.show()
            return scope
        logout: ->

    angular.extend @, {
        login: login
        logout: logout
        isLoggedin: isLoggedin
        getUser: getUser
        ui: ui
    }

#    @ui =
#        show: ->
#            $ionicModal.fromTemplateUrl(
#                _dialogTemplate, scope: $rootScope
#            ).then (modal) ->
#                _modal = modal
#                _modal.show()
#            return
#
#        hide: ->
#            _modal.hide() if _modal
#            $state.go _stateFrom.name if _stateFrom and _stateFrom.name
#            return
#
#        submit: =>
#            data = $rootScope.authen
#
#            if !data.username or !data.password
#                $rootScope.authen.error = 'Empty username or password.'
#                throw new Error('Please implement form validation on your controller.')
#
#            @login data.username, data.password
#            return
#
#    # init authen util
#    $rootScope.authen =
#        username: null
#        password: null
#        error: null
#        busy: no
#        ui: @ui
#        isLoggedin: -> OAuth.isAuthenticated()
#
#    # route change exceptor
#    $rootScope.$on '$stateChangeStart', (event, to, from) ->
#        return if !to.secure or OAuth.isAuthenticated()
#        _stateTo = to
#        _stateFrom = from
#
#        # puse event
#        event.preventDefault()
#
#        # show login dialog
#        $rootScope.authen.ui.show()
#        return
#
#    $rootScope.$on 'event:auth-loginRequired', ->
#        $rootScope.authen.ui.show()
#        return
#
#    $rootScope.$on 'event:auth-forbidden', ->
#        OAuth.getRefreshToken().then _getUserInfo , _somethingWrong
#        return
#
#    $rootScope.$on 'event:auth-loginConfirmed', ->
#        _modal.hide()
#        $state.go _stateTo.name if _stateTo and _stateTo.name
#        return

    return @
