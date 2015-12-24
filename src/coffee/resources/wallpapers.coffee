class Wallpapers extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceWallpapersCache'

    url = CFG.API.getPath('wallpapers/')
    paramDefaults = {}
    actions =
        getPage:
            url: CFG.API.getPath('wallpapers/')
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
                for value, index in newData.items
                    fields =
                        id: 'id'
                        name: 'name'
                        image: 'image.media.url'
                    newData.items[index] = Helper.traverseProperties value, fields
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
