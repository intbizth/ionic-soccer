class MicroChats extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('micro-chats/'), {}, {
        getPage:
            url: CFG.API.getPath('micro-chats/latest/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 20
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
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
                        message: 'message'
                        image: 'image'
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
    })

    return resource
