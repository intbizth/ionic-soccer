class Users extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Clubs, Helper
) ->
    timeout = 20000
    cache = $cacheFactory 'resourceUsersCache'

    url = CFG.API.getPath('users/')
    paramDefaults = {}
    actions =
        register:
            url: CFG.API.getPath('users/register')
            method: 'POST'
            responseType: 'json'
            transformRequest: (data, headersGetter) ->
                return Helper.buildFormData data
            timeout: timeout
        info:
            url: CFG.API.getPath('me')
            method: 'GET'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                clubs = new Clubs()
                fields =
                    id: 'id'
                    birthday: 'profile.birthday'
                    country: 'country'
                    club: 'club'
                    displayname: 'displayname'
                    favoriteClubs: 'favorite_clubs'
                    gender: 'profile.gender'
                    enabled: 'enabled'
                    mobile: 'profile.mobile'
                    profilePicture: '_links.profile_picture.href'
                    username: 'username'
                    usernameCanonical: 'username_canonical'
                    firstName: 'profile.first_name'
                    lastName: 'profile.last_name'
                    email: 'profile.email'
                    emailCanonical: 'profile.email_canonical'
                newData = Helper.traverseProperties newData, fields
                newData.club = clubs.transformItemData(newData.club)
                angular.forEach newData.favoriteClubs, (value, key) ->
                    newData.favoriteClubs[key] = clubs.transformItemData(newData.favoriteClubs[key])
                console.warn 'newData', newData
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.removeAll()
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
        testgetlogin:
            url: 'http://192.168.10.250/test-get-login.php'
            method: 'GET'
            responseType: 'json'
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    username: 'username'
                    password: 'password'
                newData = Helper.traverseProperties newData, fields
                return newData
            timeout: timeout
    options = {}
    extend = {}

    resource = $resource url, paramDefaults, actions, options
    resource.prototype = angular.extend extend, resource.prototype
    return resource
