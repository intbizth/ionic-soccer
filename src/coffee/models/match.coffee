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
    CFG, NgBackboneModel, Club
) ->
    return NgBackboneModel.extend
        # root url for single model.
        url: CFG.API.getPath 'matches/'

        relations: [{
            type: 'HasOne'
            key: 'home_club'
            relatedModel: Club
        }, {
            type: 'HasOne'
            key: 'away_club'
            relatedModel: Club
        }]
