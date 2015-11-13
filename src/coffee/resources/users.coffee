class Users extends Factory then constructor: (
    $resource, CFG, Helper
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('users'), {}, {
        register:
#            url: CFG.API.getPath('users/register')
            url: 'http://192.168.10.250:8000/api/users/register'
            method: 'POST'
#            params:
#                firstname: 'firstname'
#                lastname: 'lastname'
#                email: 'email'
#            responseType: 'json'
            transformResponse: (data, headersGetter) ->
                console.warn 'transformResponse', data
            timeout: timeout
    })

    return resource
