class Products extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 20000
    cache = $cacheFactory 'resourceProductsCache'

    url = CFG.API.getPath('product/:id')
    paramDefaults = {}
    actions =
        getPage:
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
                        id: 'id'
                        name: 'name'
                        price: 'price'
                        image: 'image.media.url'
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
        getId:
            method: 'GET'
            params:
                id: '@id'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    name: 'name'
                    model: 'model'
                    description: 'description'
                    price: 'price'
                    moreDescription: 'more_description'
                    image: 'image.media.url'
                return Helper.traverseProperties newData, fields
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
