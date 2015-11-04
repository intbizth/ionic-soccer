class Products extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('product/:id'), {}, {
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
                        name: 'name'
                        price: 'price'
                        image: 'image.media.url'
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
                    name: 'name'
                    model: 'model'
                    description: 'description'
                    price: 'price'
                    moreDescription: 'more_description'
                    image: 'image.media.url'
                return Helper.traverseProperties data, fields
            timeout: timeout
    })

    return resource