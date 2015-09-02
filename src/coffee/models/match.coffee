class Matches extends Factory then constructor: (CFG, NgBackboneCollection, Match) ->
    return NgBackboneCollection.extend
        model: Match
        url: CFG.API.getPath 'matches/'

class Match extends Factory then constructor: (NgBackboneModel, Club, Clubs) ->
    return NgBackboneModel.extend
        relations: [{
            type: 'HasOne'
            key: 'home_club'
            relatedModel: Club
        }, {
            type: 'HasOne'
            key: 'away_club'
            relatedModel: Club
        }]
