class ClubTickets extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceClubTicketsCache'

    url = CFG.API.getPath('club-tickets/')
    paramDefaults = {}
    actions =
        getPage:
            url: CFG.API.getPath('club-tickets/latest/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 1
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
                for value, index in newData.items
                    fields =
                        id: 'id'
                        stadiumImage: '_links.stadium.href'
                        generalTickets: 'configuration.general_ticket'
                        ticketZones: 'ticket_zones'
                        seasonTicket: 'configuration.season_ticket'
                        note: 'configuration.note'
                    newData.items[index] = Helper.traverseProperties value, fields
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
