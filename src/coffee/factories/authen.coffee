class Authen extends Factory then constructor: (
    $ionicModal, $q, $rootScope, $sessionStorage, $state, authService, OAuth, OAuthToken, Users
) ->
    _modal = null
    _stateTo = null
    _stateFrom = null
    _dialogTemplate = null

    _reset = ->
        delete $sessionStorage.user
        OAuthToken.removeToken()
        $rootScope.authen.busy = no

    _getUserInfo = (args) ->
        flush = if args && args.flush then args.flush else no
        users = new Users()
        users.$info(
            flush: flush
        , (success) ->
            console.warn '$info:success', success
            $sessionStorage.user = success
            authService.loginConfirmed $sessionStorage.user, (config) ->
                return config
        , (error) ->
            console.warn '$info:error', error
            _somethingWrong error
        )

    _somethingWrong = (error) ->
        _reset()
        if error.status is 400
            $rootScope.authen.error = error.error_description
        else if error.status is 500
            $rootScope.authen.error = error.statusText

    @init = (params) ->
        _dialogTemplate = params.dialogTemplate || 'templates/user/login.html'

    @login = (username, password) ->
        $rootScope.authen.busy = yes
        return $q((resolve, reject)->
            OAuth.getAccessToken({
                username: username
                password: password
            }).then((success) ->
                console.warn 'OAuth.getAccessToken:success', success
                _getUserInfo(flush: yes)
                resolve()
            , (error) ->
                console.error 'OAuth.getAccessToken:error', error
                _somethingWrong error
                reject()
            )
        )

    @logout = (rejection) ->
        _reset()
        $rootScope.$broadcast('event:auth-logout', rejection)
        return

    @getUser = (args) -> _getUserInfo args

    @ui =
        show: ->
            $ionicModal.fromTemplateUrl(
                _dialogTemplate, scope: $rootScope
            ).then (modal) ->
                _modal = modal
                _modal.show()
            return

        hide: ->
            _modal.hide() if _modal
            $state.go _stateFrom.name if _stateFrom and _stateFrom.name
            return

        submit: =>
            data = $rootScope.authen

            if !data.username or !data.password
                $rootScope.authen.error = 'Empty username or password.'
                throw new Error('Please implement form validation on your controller.')

            @login data.username, data.password
            return

    # init authen util
    $rootScope.authen =
        username: null
        password: null
        error: null
        busy: no
        ui: @ui
        isLoggedin: -> OAuth.isAuthenticated()

    # route change exceptor
    $rootScope.$on '$stateChangeStart', (event, to, from) ->
        return if !to.secure or OAuth.isAuthenticated()
        _stateTo = to
        _stateFrom = from

        # puse event
        event.preventDefault()

        # show login dialog
        $rootScope.authen.ui.show()
        return

    $rootScope.$on 'event:auth-loginRequired', ->
        $rootScope.authen.ui.show()
        return

    $rootScope.$on 'event:auth-forbidden', ->
        OAuth.getRefreshToken().then _getUserInfo , _somethingWrong
        return

    $rootScope.$on 'event:auth-loginConfirmed', ->
        _modal.hide()
        $state.go _stateTo.name if _stateTo and _stateTo.name
        return

    return @
