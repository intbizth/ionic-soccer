class Papers extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourcePapersCache'

    url = CFG.API.getPath('news/')
    paramDefaults = {}
    actions =
        getPage:
            url: CFG.API.getPath('news/published')
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
                        headline: 'headline'
                        subhead: 'subhead'
                        description: 'description'
                        highlight: 'highlight'
                        content: 'content'
                        creditUrl: 'credit_url'
                        image: '_links.image.href'
                        cover: '_links.cover.href'
                        user:
                            id: 'user.id'
                            displayname: 'user.displayname'
                            profilePicture: 'user.profile_picture'
                        publishedDate: 'published_date'
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
        getId:
            url: CFG.API.getPath('news/:id')
            method: 'GET'
            params:
                id: '@id'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    headline: 'headline'
                    subhead: 'subhead'
                    description: 'description'
                    highlight: 'highlight'
                    content: 'content'
                    creditUrl: 'credit_url'
                    image: '_links.image.href'
                    cover: '_links.cover.href'
                    user:
                        id: 'user.id'
                        displayname: 'user.displayname'
                        profilePicture: 'user.profile_picture'
                    publishedDate: 'published_date'
                newData = Helper.traverseProperties newData, fields
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
