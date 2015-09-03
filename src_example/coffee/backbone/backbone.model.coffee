class NgBackboneModel extends Factory then constructor: (
    $rootScope, NgBackbone, Und
) ->
    # Usage: model.$attributes.someKey
    propertyAccessor = (key) ->
        Object.defineProperty @$attributes, key,
            enumerable: true
            configurable: true
            get: => @get key
            set: (newValue) =>
                @set key, newValue
                return
        return

    # Usage: model.someKey
    propertyQuickAccessor = (key) ->
        Object.defineProperty @, key,
            enumerable: true
            configurable: true
            get: =>
                if Und.isDefined(@attributes[key])
                    return @$attributes[key]
                else
                    return @[key]

            set: (newValue) =>
                if Und.isDefined(@attributes[key])
                    @attributes[key] = newValue
                else @[key] = newValue
                return
        return

    return NgBackbone.RelationalModel.extend
        constructor: ->
            @$status =
                deleting: false
                loading: false
                saving: false
                syncing: false

            @on 'request', (model, xhr, options) ->
                method = options.method.toUpperCase()
                @setStatus
                    deleting: method == 'DELETE'
                    loading: method == 'GET'
                    saving: method == 'POST' or method == 'PUT'
                    syncing: true

            @on 'sync error', @resetStatus
            return NgBackbone.RelationalModel.apply @, arguments

        set: (key, val, options) ->
            output = NgBackbone.RelationalModel::set.apply @, arguments

            # Do not set binding if attributes are invalid
            @setBinding key, val, options
            return output

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
                deleting: false
                loading: false
                saving: false
                syncing: false

        setBinding: (key, val, options) ->
            return @ if Und.isUndefined(key)

            if Und.isObject(key)
                attrs = key
                options = val
            else (attrs = {})[key] = val

            options = options or {}
            @$attributes = {} if Und.isUndefined(@$attributes)
            unset = options.unset

            for attr of attrs
                if unset and @$attributes.hasOwnProperty(attr)
                    delete @$attributes[attr]
                else if !unset and !@$attributes[attr]
                    propertyAccessor.call @, attr
                    propertyQuickAccessor.call @, attr
            return @

        removeBinding: (attr, options) ->
            @setBinding attr, undefined, Und.extend({}, options, unset: true)
