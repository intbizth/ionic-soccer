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
                    baseUrl: 'http://chonburifc.balltoro.com/api/'
                oauth:
                    baseUrl: 'http://chonburifc.balltoro.com'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'
            prod:
                api:
                    baseUrl: 'http://chonburifc.balltoro.com/api/'
                oauth:
                    baseUrl: 'http://chonburifc.balltoro.com'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'
            sim:
                api:
                    baseUrl: 'http://chonburifc.balltoro.com/api/'
                oauth:
                    baseUrl: 'http://chonburifc.balltoro.com'
                    grantPath: '/oauth/v2/token'
                    clientId: '37qroinr7u804og8gs8ss448kkg0cocwkc4g8kgc8gog8w0gk0'
                    clientSecret: 'mp02ptgi09w40c0wswksgwws888sgocgg84ckgkcso0o4owc4'
        GOOGLE:
            analytics:
                id: 'UA-69117679-1'
        clubId: 28

    ApiConfig = Config.ENVIRONMENT['@@environment'].api
    OAuthConfig = Config.ENVIRONMENT['@@environment'].oauth

    return angular.extend Config,
        API:
            getPath: (path) -> ApiConfig.baseUrl + path
            getProxy: -> ApiConfig.proxy
            getBaseUrl: -> ApiConfig.baseUrl
        OAuth:
            getConfig: -> OAuthConfig
