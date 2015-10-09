class Matches extends Factory then constructor: (
    NgBackboneCollection, Match
) ->
    # backbone need to return its self when construct.
    return NgBackboneCollection.extend
        model: Match

        # using url same as model's url.
        url: Match::url

        # defind alias name to refer to this collection in application wide
        # eg. $rootScope.$matches
        alias: 'matches'

class Match extends Factory then constructor: (
    CFG, NgBackboneModel, Club, Season, Helper, Und
) ->
    return NgBackboneModel.extend
        # root url for single model.
        url: CFG.API.getPath 'matches/'
        relations: [
            type: 'HasOne'
            key: 'home_club'
            relatedModel: Club
        ,
            type: 'HasOne'
            key: 'away_club'
            relatedModel: Club
        ,
            type: 'HasOne'
            key: 'season'
            relatedModel: Season
        ]
        dataTranformToFixture: ->
            item =
                id: 'id'
                is_live: 'is_live'
                is_half_time: 'is_half_time'
                is_full_time: 'is_full_time'
                homeClub:
                    id: 'home_club.id'
                    name: 'home_club.name'
                    short_name: 'home_club.short_name'
                    logo: 'home_club._links.logo_70x70.href'
                    score: 'home_score'
                awayClub:
                    id: 'away_club.id'
                    name: 'away_club.name'
                    short_name: 'away_club.short_name'
                    logo: 'away_club._links.logo_70x70.href'
                    score: 'away_score'
                startTime: 'start_time'
            item = Helper.traverseProperties @, item
            item.type = 'label'
            item.template = 'before'
            return item
        dataTranformToResults: ->
            item =
                id: 'id'
                is_live: 'is_live'
                is_half_time: 'is_half_time'
                is_full_time: 'is_full_time'
                homeClub:
                    id: 'home_club.id'
                    name: 'home_club.name'
                    short_name: 'home_club.short_name'
                    logo: 'home_club._links.logo_70x70.href'
                    score: 'home_score'
                awayClub:
                    id: 'away_club.id'
                    name: 'away_club.name'
                    short_name: 'away_club.short_name'
                    logo: 'away_club._links.logo_70x70.href'
                    score: 'away_score'
                startTime: 'start_time'
            item = Helper.traverseProperties @, item
            item.type = 'label'
            item.template = 'after'
            return item
        dataTranformToLive: ->
            item =
                id: 'id'
                streaming: 'streaming'
                homeClub:
                    id: 'home_club.id'
                    name: 'home_club.name'
                    short_name: 'home_club.short_name'
                    logo: 'home_club._links.logo_70x70.href'
                    score: 'home_score'
                awayClub:
                    id: 'away_club.id'
                    name: 'away_club.name'
                    short_name: 'away_club.short_name'
                    logo: 'away_club._links.logo_70x70.href'
                    score: 'away_score'
                startTime: 'start_time'
            item = Helper.traverseProperties @, item
            item.type = 'label'
            item.template = 'after'
            return item
        dataTranformToMatchEvents: ->
            item =
                id: 'id'
                isLive: 'is_live'
                isHalfTime: 'is_half_time'
                isFullTime: 'is_full_time'
                endMatch: 'end_match'
                activities: 'activities'
            item = Helper.traverseProperties @, item
            if item.activities.length > 0
                item.activities = Und.map item.activities, (itemActivity) ->
                    activity =
                        id: 'id'
                        actor: 'actor'
                        time: 'activity_time'
                        side: 'activity_side'
                        type: 'activity_type'
                        ownGoal: 'own_goal'
                    itemActivity = Helper.traverseProperties itemActivity, activity
                    itemActivity.dot = 'normal'
                    itemActivity.icon = if itemActivity.type != 'score' then itemActivity.type else 'goal'
                    return itemActivity
                item.activities.unshift(
                    id: 'id'
                    actor: null
                    time: 0
                    description: 'เริ่มการแข่งขัน'
                    side: 'away'
                    type: null
                    dot: 'large'
                )
                if item.isHalfTime
                    item.activities.push(
                        id: 'id'
                        actor: null
                        time: 45
                        description: 'ครึ่งหลัง'
                        side: 'away'
                        type: null
                        dot: 'halftime'
                    )
                item.activities = Und.sortBy(item.activities, (value) ->
                    return parseFloat value.time
                )
                if item.isFullTime
                    item.activities.push(
                        id: 'id'
                        actor: null
                        time: null
                        description: 'จบการแข่งขัน'
                        side: 'away'
                        type: null
                        dot: 'large'
                    )
                item.activities.reverse()
            return item
