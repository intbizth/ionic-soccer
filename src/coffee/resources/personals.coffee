class Personals extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 20000
    cache = $cacheFactory 'resourcePersonalsCache'

    url = CFG.API.getPath('personals/')
    paramDefaults = {}
    actions =
        getClubMe:
            url: CFG.API.getPath('personals/club/' + CFG.clubId)
            method: 'GET'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                newData = Helper.traverseProperties newData, fields
                angular.forEach newData.items, (value, key) ->
                    fields =
                        id: 'id'
                        no: 'no'
                        fullname: 'fullname'
                        image: 'image.media.url'
                        position:
                            name: 'position.name'
                            shortName: 'position.short_name'
                    newData.items[key] = Helper.traverseProperties value, fields
                if newData.page < newData.pages
                    newData.next = newData.page + 1
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.removeAll()
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
        getId:
            url: CFG.API.getPath('personals/:id')
            method: 'GET'
            params:
                id: '@id'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    no: 'no'
                    age: 'age'
                    fullname: 'fullname'
                    firstname: 'firstname'
                    lastname: 'lastname'
                    nickname: 'nickname'
                    birthday: 'birthday'
                    image: 'image.media.url'
                    bio: 'bio'
                    position:
                        name: 'position.name'
                        shortName: 'position.short_name'
                    previousClub:
                        id: 'previous_club.id'
                        name: 'previous_club.name'
                        startDate: 'last_club_personal.start_date'
                        signedDate: 'last_club_personal.signed_date'
                newData = Helper.traverseProperties newData, fields
                newData.score =
                    yellow: 0
                    red: 0
                    goal: 0
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
