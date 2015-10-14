class NgBackbone extends Factory then constructor: (
    $http, CFG, Und
) ->
    methodMap =
        create: 'POST'
        update: 'PUT'
        patch: 'PATCH'
        delete: 'DELETE'
        read: 'GET'

    http = -> $http.apply $http, arguments
    sync = (method, model, options) ->
        # Default options to empty object
        if Und.isUndefined options
            options = {}

        httpMethod = options.method or methodMap[method]
        params = method: httpMethod

        if !options.url and Und.isDefined model.url
            params.url = model.url

        if Und.isUndefined(options.data) and model and (httpMethod == 'POST' or httpMethod == 'PUT' or httpMethod == 'PATCH')
            params.data = angular.toJson(options.attrs or model.toJSON(options))

        # AngularJS $http doesn't convert data to querystring for GET method
        if httpMethod == 'GET' and Und.isDefined options.data
            params.params = options.data

#        console.log('NgBackbone:options', JSON.stringify(options))

        xhr = http Und.extend(params, options)
        xhr.then (data, status, headers, config) ->
            #console.log 'xhr then'
            options.xhr =
                status: status
                headers: headers
                config: config

#            console.log('NgBackbone:headers', JSON.stringify(headers))
#            console.log('NgBackbone:status', JSON.stringify(status))
#            console.log('NgBackbone:data', JSON.stringify(data))
#            console.log('NgBackbone:config', JSON.stringify(config))

            if Und.isDefined(options.success) and Und.isFunction(options.success)
                options.success data
            return

        xhr.catch (data, status, headers, config) ->
            options.xhr =
                status: status
                headers: headers
                config: config

#            console.error('NgBackbone:headers', JSON.stringify(headers))
#            console.error('NgBackbone:status', JSON.stringify(status))
#            console.error('NgBackbone:data', JSON.stringify(data))
#            console.error('NgBackbone:config', JSON.stringify(config))

            if Und.isDefined(options.error) and Und.isFunction(options.error)
                options.error data
            return

        model.trigger 'request', model, xhr, Und.extend(params, options)
        return xhr

    # Override Backbone ajax request
    return Und.extend Backbone,
        sync: sync
        ajax: http
