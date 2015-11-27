class TicketMatches extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceTicketMatchesCache'

    url = CFG.API.getPath('ticket-matches/')
    paramDefaults = {}
    actions =
        getMatch:
            url: CFG.API.getPath('ticket-matches/match/:id')
            method: 'GET'
            params:
                page: 1
                limit: 20
                id: '@id'
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
                        id: 'id'
                        code: 'ticket_zone.code'
                        balance: 'balance'
                        label: 'ticket_zone.label'
                    newData.items[key] = Helper.traverseProperties value, fields
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
