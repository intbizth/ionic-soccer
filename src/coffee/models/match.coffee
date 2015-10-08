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
    CFG, NgBackboneModel, Club, Season, Helper
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
                steaming: 'steaming'
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
        dataTranformToMatchEvent: ->
            item =
                id: 'id'
                activities: 'activities'
            return Helper.traverseProperties @, item
