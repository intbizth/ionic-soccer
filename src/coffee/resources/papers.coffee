class Papers extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('news/:id'), {}, {
        getPage:
            method: 'GET'
            params:
                page: 1
                limit: 20
            responseType: 'json'
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
    })

    return resource
