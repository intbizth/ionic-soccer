class Papers extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 20000
    cache = $cacheFactory 'resourcePapersCache'

    url = CFG.API.getPath('news/:id')
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
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                data = Helper.traverseProperties data, fields
                angular.forEach data.items, (value, key) ->
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
                    data.items[key] = Helper.traverseProperties value, fields
                if data.page < data.pages
                    data.next = data.page + 1
                return data
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
                return Helper.traverseProperties data, fields
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}

    return $resource url, paramDefaults, actions, options
