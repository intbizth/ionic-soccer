class NgBackboneCollection extends Factory then constructor: (
    CFG, NgBackbone, NgBackboneModel, $rootScope, $ionicLoading, Und
) ->
    # TODO: to move up `backbone` into abstract layer inject me as dependency!! or override in sub-class
    PROXY = CFG.API.getProxy()
    BASE_URL = CFG.API.getBaseUrl()

    # TODO:
    # - subscribe `reset` to make `ordering` of fullCollection to
    #   `append` or `prepend` eg. in `pull-refuesh` it make sense to be `prepend`

    return NgBackbone.PageableCollection.extend
        model: NgBackboneModel

        # see more https://github.com/backbone-paginator/backbone.paginator
        mode: 'infinite'

        state:
            pageSize: 10
            total: 0

        queryParams:
            pageSize: 'limit'
            totalRecords: 'total'
            totalPages: 'pages'

        constructor: ->
            Object.defineProperty @, '$collection',
                enumerable: no
                get: =>
                    return @fullCollection.models if @mode == 'infinite'
                    return @models

            # initialize status object
            @$status =
                deleting: no
                loading: no
                saving: no
                syncing: no

            @on 'request', (model, xhr, options) ->
                method = options.method.toUpperCase()
                @setStatus
                    deleting: method == 'DELETE'
                    loading: method == 'GET'
                    saving: method == 'POST' or method == 'PUT'
                    syncing: no

            @on 'sync error', @resetStatus
            @on 'destroy', @resetStatus
            @on 'sync', -> $rootScope.$broadcast 'scroll.infiniteScrollComplete' if @mode == 'infinite'

            NgBackbone.PageableCollection.apply @, arguments
            return

        parseState: (resp, queryParams, state, options) ->
            @state.total = resp.data.total
            @state.totalPages = resp.data.pages
            return @state

        parseLinks: (resp, options) ->
            _links = Und.result resp.data, '_links'

            if _links
                defs = href: ''
                first = Und.result _links, 'first', defs
                next = Und.result _links, 'next', defs
                previous = Und.result _links, 'previous', defs

                return {
                    first: first.href#.replace PROXY, BASE_URL
                    next: next.href#.replace PROXY, BASE_URL
                    prev: previous#.href.replace PROXY, BASE_URL
                }
            else return NgBackbone.PageableCollection::parseLinks.apply @, arguments

        # parse hateote data
        parseRecords: (resp) ->
            data = Und.result resp.data, '_embedded'

            return data.items if data
            return resp.data

        # has more page
        hasMorePage: -> @state.total > 0 and @state.total > @state.totalRecords

        # set on request status
        setStatus: (key, value, options) ->
            return @ if Und.isUndefined(key)

            if Und.isObject(key)
                attrs = key
                options = value
            else (attrs = {})[key] = value

            options = options or {}

            for attr of @$status
                if attrs.hasOwnProperty(attr) and Und.isBoolean(attrs[attr])
                    @$status[attr] = attrs[attr]
            return

        resetStatus: ->
            @setStatus
                deleting: no
                loading: no
                saving: no
                syncing: no

        # get collection
        getCollection: -> @$collection

        ###
        # Shortcut to fetch collection.
        #
        # @param {object} options The `options` can be `$scope` for short-hand or
        #    {
        #        scope: $scope
        #        storeKey: 'store' # the name to be used in view.
        #        collectionKey: 'collection' # the name to be used in view.
        #    }
        ###
        load: (options) ->
            # need scope
            $scope = options.scope || options
            $scope[options.storeKey || 'store'] = @

            @on 'sync', (model) ->
                $scope[options.collectionKey || 'collection'] = model.$collection
                $ionicLoading.hide()

            # start loading first page.
            $ionicLoading.show()
            @getFirstPage()
            return @
