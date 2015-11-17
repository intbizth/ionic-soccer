class GamesScores extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 20000
    cache = $cacheFactory 'resourceGamesScoresCache'

    url = CFG.API.getPath('games-scores/')
    paramDefaults = {}
    actions =
        getPage:
            url: CFG.API.getPath('games-scores/result/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 20
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                newData = Helper.traverseProperties newData, fields
                angular.forEach newData.items, (value, key) ->
                    fields =
                        id: ''
                        profilePicture: 'user.profile_picture'
                        displayName: 'user.displayname'
                        times: 'times'
                        points: 'points'
                    newData.items[key] = Helper.traverseProperties value, fields
                if newData.page < newData.pages
                    newData.next = newData.page + 1
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.removeAll()
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
