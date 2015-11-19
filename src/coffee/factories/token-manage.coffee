class TokenManage extends Factory then constructor: (
    $cordovaSQLite, $interval, $ionicPlatform, $rootScope, $sessionStorage, $q, Moment, OAuth
) ->
    db = null
    timer = null
    refreshing = no

    init = ->
        deferred = $q.defer()

        db.transaction((tx) ->
            tx.executeSql 'CREATE TABLE IF NOT EXISTS `token` (`data` TEXT NULL, `expires_at` INTEGER NULL)'
        , (error) ->
            deferred.reject error
        , ->
            deferred.resolve()
        )

        return deferred.promise

    encode = (value) ->
        encodeURIComponent angular.toJson value

    decode = (value) ->
        angular.fromJson decodeURIComponent value

    now = ->
        Moment().unix()

    getToken = ->
        deferred = $q.defer()

        db.transaction((tx) ->
            tx.executeSql 'SELECT `data`, `expires_at` FROM `token`', [], (tx, res) ->
                item = null
                if res.rows.length > 0
                    item = {}
                    data = res.rows.item(0).data
                    if data != null
                        data = decode data
                    item.data = data
                    item.expiresAt = res.rows.item(0).expires_at
                deferred.resolve item
                console.warn 'getToken', item
        , (error) ->
            deferred.reject error
        )

        return deferred.promise

    setToken = (data) ->
        console.warn 'setToken1', data
        expiresAt = null
        if data != null
#            expiresAt = now() + data.expires_in
            expiresAt = now() + 30
            data = encode data

        deferred = $q.defer()
        console.warn 'setToken2', data, expiresAt
        db.transaction((tx) ->
            tx.executeSql 'INSERT INTO `token` (`data`, `expires_at`) VALUES (?, ?)', [data, expiresAt]
        , (error) ->
            deferred.reject error
        , ->
            deferred.resolve data
        )

        return deferred.promise

    removeToken = ->
        deferred = $q.defer()

        db.transaction((tx) ->
            tx.executeSql 'DELETE FROM `token`'
        , (error) ->
            deferred.reject error
        , ->
            deferred.resolve()
        )

        return deferred.promise

    startRefreshToken = ->
        stopRefreshToken()
        promise = getToken()
        promise.then((success) ->
            console.warn 'startRefreshToken.getToken', success
            if success != null
                timer = $interval(->
                    console.warn now(), success.expiresAt, (success.expiresAt) - now()
                    if (success.expiresAt) - now() <= 0 and !refreshing
                        refreshToken()
                , 1000)
        , (error) ->
            console.error 'startRefreshToken.getToken', error
        )

    stopRefreshToken = ->
        $interval.cancel timer
        timer = undefined

    refreshToken = ->
        refreshing = yes
        OAuth.getRefreshToken().then((success) ->
            console.warn 'OAuth.getRefreshToken:ok', success
            $sessionStorage.token = success.data
            refreshing = no
        , (error) ->
            console.warn 'OAuth.getRefreshToken:error', error
            refreshing = no
        )

    angular.extend @, {
        getToken: getToken
        setToken: setToken
        removeToken: removeToken
        startRefreshToken: startRefreshToken
        stopRefreshToken: stopRefreshToken
        refreshToken: refreshToken
    }

    $ionicPlatform.ready ->
        db = $cordovaSQLite.openDB name: 'database.db', location: 2
        init()

    return @