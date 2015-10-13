class CFG extends Constant then constructor: ->
    Config =
        VERSION: '0.0.1'
        HTTP_STATUS_CODES:
            '401': 'Unauthorized'
            '403': 'Forbidden'
            '404': 'Not Found'
            '500': 'Internal Service Error'

        ENVIRONMENT:
            dev:
                api:
                    baseUrl: 'http://127.0.0.1:8000/api/'
                oauth:
                    baseUrl: 'http://127.0.0.1:8000'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    # TODO: store on proxy server
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'

            prod:
                api:
                    baseUrl: 'http://demo.balltoro.com/api/'
                oauth:
                    baseUrl: 'http://127.0.0.1:8000'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    # TODO: store on proxy server
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'

            sim:
                api:
                    baseUrl: 'http://127.0.0.1:8000/api/'
                oauth:
                    baseUrl: 'http://127.0.0.1:8000'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    # TODO: store on proxy server
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'

    ApiConfig = Config.ENVIRONMENT['@@environment'].api
    OAuthConfig = Config.ENVIRONMENT['@@environment'].oauth

    return angular.extend Config,
        API:
            getPath: (path) -> ApiConfig.baseUrl + path
            getProxy: -> ApiConfig.proxy
            getBaseUrl: -> ApiConfig.baseUrl
            getUserInfo: -> ApiConfig.baseUrl + 'me'

        OAuth:
            getConfig: -> OAuthConfig
