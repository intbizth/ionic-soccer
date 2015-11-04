class Papers extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper, Und
) ->
    timeout = 20000
    cache = $cacheFactory 'resourcePapersCache'
    interceptor =
        response: (response) ->
            cache.remove response.config.url
            return response.data || {}

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
                data.items = Und.map data.items, (item) ->
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
                    return Helper.traverseProperties item, fields
                if data.page < data.pages
                    data.next = data.page + 1
                return data
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
            timeout: timeout
    options = {}

    actionsClone = angular.copy actions

    for key, value of actionsClone
        actionsClone[key + 'Flush'] = value
        actionsClone[key + 'Flush'].interceptor = interceptor
        delete actionsClone[key + 'Flush'].cache
        delete actionsClone[key]

    actions = angular.extend actions, actionsClone

    return $resource url, paramDefaults, actions, options
