class Authen extends Factory then constructor: (
    $ionicPlatform, $q, $rootScope, $sessionStorage, authService, TokenManage, OAuth, OAuthToken, Users
) ->
    getUser = (args) ->
        deferred = $q.defer()

        flush = if args && args.flush then args.flush else no
        if isLoggedin()
            users = new Users()
            users.$info(
                flush: flush
            , (success) ->
                $rootScope.user = success
                deferred.resolve success
            , (error) ->
                deferred.reject error
            )
        else
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
                message = ''
                if error.data and error.data.message
                    message = error.data.message
                else if error.data and error.data.error_description
                    message = error.data.error_description
                else
                    message = error.statusText
                deferred.notify message
            )
        , (error) ->
            authService.loginCancelled error, (config) ->
                return config
            message = ''
            if error.data and error.data.message
                message = error.data.message
            else if error.data and error.data.error_description
                message = error.data.error_description
            else
                 message = error.statusText
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
