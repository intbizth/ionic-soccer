class Authen extends Factory then constructor: (
    $injector, $rootScope, $ionicModal, $state, $http, $sessionStorage, OAuth, OAuthToken, authService
) ->
    _modal = null
    _stateTo = null
    _stateFrom = null
    _dialogTemplate = null
    _userInfoPath = null

    _reset = ->
        delete $sessionStorage.user
        OAuthToken.removeToken()
        $rootScope.authen.busy = no

    @init = (params) ->
        _dialogTemplate = params.dialogTemplate || 'templates/user/login.html'
        _userInfoPath = params.userInfoPath

    @login = (username, password) ->
        $rootScope.authen.busy = yes
        OAuth.getAccessToken({
            username: username
            password: password
        }).then (resp) ->
            $http.get(_userInfoPath).then (resp)->
                $sessionStorage.user = resp.data

                authService.loginConfirmed resp.data, (config) ->
                    return config

            , (err) ->
                _reset()
                $rootScope.authen.error = "Can't access to user info."

        , (err) ->
            if err.status is 500
                _reset()
                $rootScope.authen.error = err.statusText

    @logout = (rejection) ->
        _reset()
        $rootScope.$broadcast('event:auth-logout', rejection)
        return

    @getUser = -> $sessionStorage.user

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
        OAuth.getRefreshToken()
        return

    $rootScope.$on 'event:auth-loginConfirmed', ->
        _modal.hide()
        $state.go _stateTo.name if _stateTo and _stateTo.name
        return

    return @
