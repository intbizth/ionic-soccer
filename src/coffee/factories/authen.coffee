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
                console.warn '$info:success', success
                $sessionStorage.user = success
            , (error) ->
                console.warn '$info:error', error
                somethingWrong error
            )
        else
            deferred = $q.defer()
            deferred.reject()
            return deferred.promise

    somethingWrong = (error) ->
        forceLogout()
        if error.status == 400 then message = error.error_description
        else if error.status == 500 then message = error.statusText
        else message = ''

    login = (username, password) ->
        deferred = $q.defer()

        OAuth.getAccessToken({
            username: username
            password: password
        }).then((success) ->
            console.warn 'OAuth.getAccessToken:success', success
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
            console.error 'OAuth.getAccessToken:error', error
            authService.loginCancelled error, (config) ->
                return config
            deferred.reject somethingWrong error
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
        delete $sessionStorage.user
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
            console.warn '$watch', newValue, oldValue, newValue != oldValue
            if newValue != oldValue
                if angular.isUndefined newValue
                    forceLogout()
                else
                    forceLogin()
                $rootScope.$emit 'event:auth-stateChange', isLoggedin()
        )

    $rootScope.isLoggedin = isLoggedin()

    $rootScope.$on 'event:auth-forceLogin', (event, data) ->
        console.warn event, data
        forceLogin data

    $rootScope.$on 'event:auth-forceLogout', (event, data) ->
        console.warn event, data
        forceLogout()

#    $rootScope.$on 'event:auth-forbidden', (event, data) ->
#        console.warn event, data

    $rootScope.$on 'event:auth-stateChange', (event, data) ->
        $rootScope.isLoggedin = data

    return @
