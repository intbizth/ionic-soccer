class Settings extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceSettingsCache'

    url = CFG.API.getPath('settings/')
    paramDefaults = {}
    actions =
        get:
            method: 'GET'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    contactEmail: 'parameters.contact_email'
                    siteUrl: 'parameters.site_url'
                    socialFacebook: 'parameters.social_facebook'
                    socialTwitter: 'parameters.social_twitter'
                    socialPinterest: 'parameters.social_pinterest'
                    socialGoogle: 'parameters.social_google'
                    matchLiveStreaming: 'parameters.match_live_streaming'
                return Helper.traverseProperties newData, fields
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.removeAll()
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
