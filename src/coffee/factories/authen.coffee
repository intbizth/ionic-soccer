class Authen extends Factory then constructor: (
    $ionicPlatform, $q, $rootScope, $sessionStorage, authService, TokenManage, OAuth, OAuthToken, Users
) ->
    getUser = (args) ->
        flush = if args && args.flush then args.flush else no
        if isLoggedin()
            users = new Users()
            users.$info(
                flush: flush
            , (success) ->
                $rootScope.user = success
            , (error) ->
                return
            )
        else
            deferred = $q.defer()
            deferred.reject()
            return deferred.promise

    login = (username, password) ->
        deferred = $q.defer()

        OAuth.getAccessToken({
            username: username
            password: password
        }).then((success) ->
            promise = getUser(flush: yes)
            promise.then((success2) ->
                authService.loginConfirmed success, (config) ->
                    return config
                deferred.resolve success2
            , (error) ->
                authService.loginCancelled error, (config) ->
                    return config
                deferred.reject error
            )
        , (error) ->
            message = ''
            authService.loginCancelled error, (config) ->
                return config
            if error.status == 400 then message = error.data.error_description
            else if error.status == 500 then message = error.statusText
            deferred.reject message
        )

        return deferred.promise

    logout = ->
        forceLogout()
        return

    isLoggedin = ->
        OAuth.isAuthenticated()

    forceLogin = () ->
        TokenManage.setToken $sessionStorage.token
        TokenManage.startRefreshToken()

    forceLogout = ->
        delete $rootScope.user
        OAuthToken.removeToken()
        TokenManage.removeToken()
        TokenManage.stopRefreshToken()

    angular.extend @, {
        login: login
        logout: logout
        isLoggedin: isLoggedin
        getUser: getUser
    }

    $ionicPlatform.ready ->
        promise = TokenManage.getToken()
        promise.then((success) ->
            if success != null
                $sessionStorage.token = success
        )

        $rootScope.$watch(->
            return $sessionStorage.token
        , (newValue, oldValue) ->
            if newValue != oldValue
                if angular.isUndefined newValue
                    forceLogout()
                else
                    forceLogin()
                $rootScope.$emit 'event:auth-stateChange', isLoggedin()
        )

    $rootScope.isLoggedin = isLoggedin()

    $rootScope.$on 'event:auth-forceLogin', (event, data) ->
        forceLogin data

    $rootScope.$on 'event:auth-forceLogout', (event, data) ->
        forceLogout()

    $rootScope.$on 'event:auth-forbidden', (event, data) ->
        TokenManage.refreshToken()

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $rootScope.isLoggedin = data

    return @
