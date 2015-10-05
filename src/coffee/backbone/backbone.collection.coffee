class NgBackboneCollection extends Factory then constructor: (
    CFG, NgBackbone, NgBackboneModel, $q, $rootScope, Und
) ->
    # TODO: to move up `backbone` into abstract layer inject me as dependency!! or override in sub-class
    PROXY = CFG.API.getProxy()
    BASE_URL = CFG.API.getBaseUrl()

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

        numLoaded: 0
        prepend: no

        constructor: (models, options) ->
            if options and options.url
                @url = options.url

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
            @on 'sync', ->
                $rootScope.$broadcast 'scroll.infiniteScrollComplete' if @mode == 'infinite'

            # handle prepend/append mode
            @on 'reset', (col) ->
                num = @state.totalRecords - @numLoaded

                # not first load
                if num and @numLoaded and @prepend
                    num = @state.totalRecords - num
                    models = @fullCollection.models
                    cols = models.splice 0, num

                    models = [].concat models, cols
                    @fullCollection.models = models

                @numLoaded = @state.totalRecords
                @prepend = no

            NgBackbone.PageableCollection::constructor.apply @, arguments
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
                    prev: previous.href#.replace PROXY, BASE_URL
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
            collectionKey = options.collectionKey

            delete options.collectionKey
            delete options.storeKey
            delete options.scope

            # start loading first page.
            promise = @getFirstPage options

            $q (resolve, reject) =>
                promise.then (xhr) =>
                    $scope[collectionKey || 'collection'] = @$collection
                    # store collection with `alias`
                    $rootScope['$' + @alias] = @ if @alias

                    resolve @$collection

                # error
                , (xhr) -> reject xhr

        ###
        # Shortcut to find model in the collection.
        #
        # @param {object} options The `options` can be `$scope` for short-hand or
        #    {
        #        scope: $scope
        #        key: 'r' # the name to be used in view.
        #    }
        #
        # @return Promise
        # @see https://docs.angularjs.org/api/ng/service/$q
        ###
        find: (attr, options) ->

            if !Und.isObject attr
                attr = id: attr

            # find in repo
            if options
                $scope = options.scope || options

            # need scope
            applyOptions = (model) ->
                if options
                    $scope = options.scope || options
                    $scope[options.key || 'r'] = model

            # find form loaded models.
            if $rootScope['$' + @alias]
                store = $rootScope['$' + @alias]
                if store.fullCollection
                    model = store.fullCollection.get attr.id

            # return promise
            $q (resolve, reject) =>
                if model
                    resolve model
                    applyOptions.call @, model
                else
                    # TODO: support :holder replacement (must to define url for each get, put, post, patch)
                    model = new @model()
                    promise = model.fetch
                        url: (model.url + attr.id)
                        success: (model) ->
                            resolve model
                            applyOptions.call @, model
                        error: (xhr) ->
                            reject xhr
                            applyOptions.call @, null
