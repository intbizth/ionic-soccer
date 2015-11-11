class Users extends Factory then constructor: (
    $resource, CFG, Helper
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('users'), {}, {
        register:
            url: CFG.API.getPath('users/register')
            method: 'GET'
            responseType: 'json'
            transformResponse: (data, headersGetter) ->
                console.warn 'transformResponse', data
            timeout: timeout
    })

    return resource
