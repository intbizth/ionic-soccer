class Matches extends Factory then constructor: (
    NgBackboneCollection, Match, Und, Helper
) ->
    # backbone need to return its self when construct.
    dataTranform =
        competitionTable:
            fixture: (models) ->
                items = []
                if Und.isUndefined models
                    return items
                for model in models
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
                    item = Helper.traverseProperties(model, item)
                    item.type = 'label'
                    if !item.is_live and !item.is_half_time and !item.is_full_time
                        item.template = 'before'
                    if item.is_full_time
                        item.template = 'after'
                    items.push item
                return items

    return NgBackboneCollection.extend
        model: Match

        # using url same as model's url.
        url: Match::url

        # defind alias name to refer to this collection in application wide
        # eg. $rootScope.$matches
        alias: 'matches'

        dataTranform: dataTranform

class Match extends Factory then constructor: (
    CFG, NgBackboneModel, Club, Season
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
