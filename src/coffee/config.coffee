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
                    baseUrl: 'http://demo.balltoro.com/api/'
                    proxy: ''
            prod:
                api:
                    baseUrl: 'http://api.balltoro.com/api/'
                    proxy: ''
            sim:
                api:
                    #baseUrl: 'http://127.0.0.1:8000'
                    baseUrl: 'http://demo.balltoro.com/api/'
                    proxy: ''
    ApiConfig = Config.ENVIRONMENT['@@environment'].api
    return angular.extend Config,
        API:
            getPath: (path) -> ApiConfig.baseUrl + path
            getProxy: -> ApiConfig.proxy
            getBaseUrl: -> ApiConfig.baseUrl
