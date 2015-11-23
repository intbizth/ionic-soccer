class TokenManage extends Factory then constructor: (
    $cordovaSQLite, $interval, $ionicPlatform, $rootScope, $sessionStorage, $q, Moment, OAuth
) ->
    db = null
    timer = null
    refreshing = no
    beforeTime = 60

    init = ->
        deferred = $q.defer()

        db.transaction((tx) ->
            tx.executeSql 'CREATE TABLE IF NOT EXISTS `token` (`data` TEXT NULL)'
            tx.executeSql 'SELECT `data` FROM `token`', [], (tx, res) ->
                if res.rows.length == 0
                    tx.executeSql 'INSERT INTO `token` (`data`) VALUES (?)', [null]
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
            tx.executeSql 'SELECT `data` FROM `token`', [], (tx, res) ->
                data = null
                if res.rows.length > 0
                    data = res.rows.item(0).data
                    if data != null
                        data = decode data
                deferred.resolve data
        , (error) ->
            deferred.reject error
        )

        return deferred.promise

    setToken = (data) ->
        if data != null
            if angular.isUndefined data.expires_at
                data.expires_at = now() + (data.expires_in - beforeTime)
            data = encode data
        deferred = $q.defer()
        db.transaction((tx) ->
            tx.executeSql 'UPDATE `token` SET `data` = ?', [data]
        , (error) ->
            deferred.reject error
        , ->
            deferred.resolve data
        )

        return deferred.promise

    removeToken = ->
        setToken(null)

    startRefreshToken = ->
        stopRefreshToken()
        promise = getToken()
        promise.then((success) ->
            if success != null
                timer = $interval(->
                    if (success.expires_at) - now() <= 0 and !refreshing
                        refreshToken()
                , 1000)
        , (error) ->
            return
        )

    stopRefreshToken = ->
        $interval.cancel timer
        timer = undefined

    refreshToken = ->
        refreshing = yes
        OAuth.getRefreshToken().then((success) ->
            $sessionStorage.token = success.data
            refreshing = no
        , (error) ->
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
