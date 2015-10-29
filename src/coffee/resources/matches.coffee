class Matches extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

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

    resource = $resource(CFG.API.getPath('matches/'), {}, {
        getLive:
            url: CFG.API.getPath('matches/live/' + CFG.clubId)
            method: 'GET'
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
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
                matchLabel = Helper.traverseProperties data, fields
                matchLabel.type = 'label'
                matchLabel.template = 'after'
                section =
                    type: 'section'
                    startTime: matchLabel.startTime || null
                matchLabel = [section ,matchLabel]
                data =
                    streaming: matchLabel.streaming || null
                    matchLabel: matchLabel
                    matchEvents: getMatchEvents data
                return data
            timeout: timeout
        getFixture:
            url: CFG.API.getPath('matches/nexts/' + CFG.clubId)
            method: 'GET'
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                data = Helper.traverseProperties data, fields
                data.items = Und.map data.items, (item) ->
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
                    item = Helper.traverseProperties item, fields
                    item.type = 'label'
                    item.template = 'before'
                    return item
                if data.page < data.pages
                    data.next = data.page + 1
                return data
            timeout: timeout
        getResults:
            url: CFG.API.getPath('matches/latest/' + CFG.clubId)
            method: 'GET'
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                data = Helper.traverseProperties data, fields
                data.items = Und.map data.items, (item) ->
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
                    item = Helper.traverseProperties item, fields
                    item.type = 'label'
                    item.template = 'before'
                    return item
                if data.page < data.pages
                    data.next = data.page + 1
                return data
            timeout: timeout
        getId:
            url: CFG.API.getPath('matches/:id')
            method: 'GET'
            params:
                id: '@id'
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
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
                matchLabel = Helper.traverseProperties data, fields
                matchLabel.type = 'label'
                matchLabel.template = 'after'
                section =
                    type: 'section'
                    startTime: matchLabel.startTime || null
                matchLabel = [section ,matchLabel]
                data =
                    matchLabel: matchLabel
                    matchEvents: getMatchEvents data
                return data
            timeout: timeout
    })

    return resource
