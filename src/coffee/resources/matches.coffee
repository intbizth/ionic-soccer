class Matches extends Factory then constructor: (
    $cacheFactory, $resource, CFG, Helper
) ->
    timeout = 60000
    cache = $cacheFactory 'resourceMatchesCache'

    getMatchEvents = (data) ->
        fields =
            id: 'id'
            isLive: 'is_live'
            isHalfTime: 'is_half_time'
            isFullTime: 'is_full_time'
            endMatch: 'end_match'
            activities: 'activities'
        data = Helper.traverseProperties data, fields
        if data.activities and data.activities.length > 0
            data.activities = Und.map data.activities, (activity) ->
                fields =
                    id: 'id'
                    actor: 'actor.fullname'
                    time: 'activity_time'
                    side: 'activity_side'
                    type: 'activity_type'
                    ownGoal: 'own_goal'
                activity = Helper.traverseProperties activity, fields
                activity.dot = 'normal'
                activity.icon = if activity.type != 'score' then activity.type else 'goal'
                return activity
            data.activities.unshift(
                id: 'id'
                actor: null
                time: 0
                description: 'เริ่มการแข่งขัน'
                side: 'away'
                type: null
                dot: 'large'
            )
            if data.isHalfTime
                data.activities.push(
                    id: 'id'
                    actor: null
                    time: 45
                    description: 'ครึ่งหลัง'
                    side: 'away'
                    type: null
                    dot: 'halftime'
                )
            data.activities = Und.sortBy(data.activities, (value) ->
                return parseFloat value.time
            )
            if data.isFullTime
                data.activities.push(
                    id: 'id'
                    actor: null
                    time: null
                    description: 'จบการแข่งขัน'
                    side: 'away'
                    type: null
                    dot: 'large'
                )
            data.activities.reverse()
        return data

    url = CFG.API.getPath('matches/')
    paramDefaults = {}
    actions =
        getToday:
            url: CFG.API.getPath('matches/today')
            method: 'GET'
            params:
                page: 1
                limit: 1
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
                        is_live: 'is_live'
                        is_half_time: 'is_half_time'
                        is_full_time: 'is_full_time'
                        homeClub:
                            id: 'home_club.id'
                            name: 'home_club.name'
                            shortName: 'home_club.short_name'
                            logo: 'home_club._links.logo_70x70.href'
                            score: 'home_score'
                        awayClub:
                            id: 'away_club.id'
                            name: 'away_club.name'
                            shortName: 'away_club.short_name'
                            logo: 'away_club._links.logo_70x70.href'
                            score: 'away_score'
                        startTime: 'start_time'
                    newData.items[key] = Helper.traverseProperties value, fields
                    newData.items[key].type = 'label'
                    newData.items[key].template = 'before'
                if newData.page < newData.pages
                    newData.next = newData.page + 1
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
        getLive:
            url: CFG.API.getPath('matches/live/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 1
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    streaming: 'streaming'
                    homeClub:
                        id: 'home_club.id'
                        name: 'home_club.name'
                        shortName: 'home_club.short_name'
                        logo: 'home_club._links.logo_70x70.href'
                        score: 'home_score'
                    awayClub:
                        id: 'away_club.id'
                        name: 'away_club.name'
                        shortName: 'away_club.short_name'
                        logo: 'away_club._links.logo_70x70.href'
                        score: 'away_score'
                    startTime: 'start_time'
                matchLabel = Helper.traverseProperties newData, fields
                matchLabel.type = 'label'
                matchLabel.template = 'after'
                section =
                    type: 'section'
                    startTime: matchLabel.startTime || null
                matchLabel = [section ,matchLabel]
                newData2 =
                    streaming: matchLabel.streaming || null
                    matchLabel: matchLabel
                    matchEvents: getMatchEvents newData
                return newData2
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
        getFixture:
            url: CFG.API.getPath('matches/nexts/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 20
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
                        is_live: 'is_live'
                        is_half_time: 'is_half_time'
                        is_full_time: 'is_full_time'
                        homeClub:
                            id: 'home_club.id'
                            name: 'home_club.name'
                            shortName: 'home_club.short_name'
                            logo: 'home_club._links.logo_70x70.href'
                            score: 'home_score'
                        awayClub:
                            id: 'away_club.id'
                            name: 'away_club.name'
                            shortName: 'away_club.short_name'
                            logo: 'away_club._links.logo_70x70.href'
                            score: 'away_score'
                        startTime: 'start_time'
                    newData.items[key] = Helper.traverseProperties value, fields
                    newData.items[key].type = 'label'
                    newData.items[key].template = 'before'
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
        getResults:
            url: CFG.API.getPath('matches/latest/' + CFG.clubId)
            method: 'GET'
            params:
                page: 1
                limit: 20
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
                        is_live: 'is_live'
                        is_half_time: 'is_half_time'
                        is_full_time: 'is_full_time'
                        homeClub:
                            id: 'home_club.id'
                            name: 'home_club.name'
                            shortName: 'home_club.short_name'
                            logo: 'home_club._links.logo_70x70.href'
                            score: 'home_score'
                        awayClub:
                            id: 'away_club.id'
                            name: 'away_club.name'
                            shortName: 'away_club.short_name'
                            logo: 'away_club._links.logo_70x70.href'
                            score: 'away_score'
                        startTime: 'start_time'
                    newData.items[key] = Helper.traverseProperties value, fields
                    newData.items[key].type = 'label'
                    newData.items[key].template = 'before'
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
        getLineUp:
            url: CFG.API.getPath('matches/:id')
            method: 'GET'
            params:
                id: '@id'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    homeClub:
                        id: 'home_club.id'
                        name: 'home_club.name'
                        logo: 'home_club._links.logo_70x70.href'
                        formation:
                            id: 'home_formation.id'
                            name: 'home_formation.name'
                            pattern: 'home_formation.pattern'
                    awayClub:
                        id: 'away_club.id'
                        name: 'away_club.name'
                        logo: 'away_club._links.logo_70x70.href'
                        formation:
                            id: 'away_formation.id'
                            name: 'away_formation.name'
                            pattern: 'away_formation.pattern'
                newData = Helper.traverseProperties newData, fields
                newData.me = if CFG.clubId == data.homeClub.id then 'homeClub' else 'awayClub'
                return newData
            then: (resolve) ->
                if !angular.isUndefined @params and !angular.isUndefined @params.flush
                    if @params.flush
                        cache.remove @url
                    delete @params.flush
                @then = null
                resolve @
            timeout: timeout
        getId:
            url: CFG.API.getPath('matches/:id')
            method: 'GET'
            params:
                id: '@id'
            responseType: 'json'
            cache: cache
            transformResponse: (data, headersGetter) ->
                newData = angular.copy data
                fields =
                    id: 'id'
                    homeClub:
                        id: 'home_club.id'
                        name: 'home_club.name'
                        shortName: 'home_club.short_name'
                        logo: 'home_club._links.logo_70x70.href'
                        score: 'home_score'
                    awayClub:
                        id: 'away_club.id'
                        name: 'away_club.name'
                        shortName: 'away_club.short_name'
                        logo: 'away_club._links.logo_70x70.href'
                        score: 'away_score'
                    startTime: 'start_time'
                matchLabel = Helper.traverseProperties newData, fields
                matchLabel.type = 'label'
                matchLabel.template = 'after'
                section =
                    type: 'section'
                    startTime: matchLabel.startTime || null
                matchLabel = [section ,matchLabel]
                newData2 =
                    matchLabel: matchLabel
                    matchEvents: getMatchEvents newData
                return newData2
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