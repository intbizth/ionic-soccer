class clubs extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceClubsCache'

    url = CFG.API.getPath('clubs/')
    paramDefaults = {}
    actions =
        getMe:
            url: CFG.API.getPath('clubs/' + CFG.clubId)
            method: 'GET'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    name: 'name'
                    shortName: 'short_name'
                    signatureName: 'signature_name'
                    estYear: 'est_year'
                    logo: 'logo.media.url'
                    stadiumCapacity: 'stadium_capacity'
                    stadiumImage: '_links.stadium_image.href'
                    website: 'website'
                    email: 'email'
                    location: 'location'
                    country:
                        id: 'country.id'
                        name: 'country.name'
                    clubClass:
                        id: 'club_class.id'
                        name: 'club_class.name'
                return Helper.traverseProperties newData, fields
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend =
        transformItemData: (data) ->
            actions.getMe.transformResponse data

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
