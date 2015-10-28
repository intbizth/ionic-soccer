class Papers extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    resource = $resource(
        CFG.API.getPath 'news/:id',
        {
            id: '@id'
        }
    )

    resource.prototype.getPage = (args, success, error) ->
        args.page = args.page || 1
        args.limit = args.limit || 20

        data = resource.prototype.$get(
            page: args.page
            limit: args.limit
        )

        data.catch (callback) ->
            error callback

        data.finally (callback, progressBack) ->

        data.then (onFulfilled, onRejected, progressBack) ->
            data = onFulfilled
            output =
                limit: data.limit || 0
                page: data.page || 0
                pages: data.pages || 0
                total: data.total || 0
                items: (data._embedded && data._embedded.items) || []
            if output.page < output.pages
                output.next = output.page + 1
            success output

    resource.prototype.getId = (id, success, error) ->
        data = resource.prototype.$get(
            id: id
        )

        data.catch (callback) ->
            error callback

        data.finally (callback, progressBack) ->

        data.then (onFulfilled, onRejected, progressBack) ->
            success onFulfilled

    resource.prototype.dataTranformToLists = (item) ->
        fields =
            id: 'id'
            headline: 'headline'
            subhead: 'subhead'
            description: 'description'
            highlight: 'highlight'
            content: 'content'
            creditUrl: 'credit_url'
            image: 'image'
            cover: 'cover'
            user:
                id: 'user.id'
                displayname: 'user.displayname'
                profilePicture: 'user.profile_picture'
            publishedDate: 'published_date'
        return Helper.traverseProperties item, fields

    resource.prototype.dataTranformToDetail = (item) ->
        fields =
            id: 'id'
            headline: 'headline'
            subhead: 'subhead'
            description: 'description'
            highlight: 'highlight'
            content: 'content'
            creditUrl: 'credit_url'
            image: 'image'
            cover: 'cover'
            user:
                id: 'user.id'
                displayname: 'user.displayname'
                profilePicture: 'user.profile_picture'
            publishedDate: 'published_date'
        return Helper.traverseProperties item, fields

    return resource
