class Competitions extends Factory then constructor: (
    NgBackboneCollection, Competition
) ->
    # backbone need to return its self when construct.
    return NgBackboneCollection.extend
        model: Competition

        # using url same as model's url.
        url: Competition::url

        # defind alias name to refer to this collection in application wide
        # eg. $rootScope.$competitions
        alias: 'competitions'

class Competition extends Factory then constructor: (
    CFG, NgBackboneModel, Country
) ->
    return NgBackboneModel.extend
        # root url for single model.
        url: CFG.API.getPath 'competitions/'

        relations: [
            type: 'HasOne'
            key: 'country'
            relatedModel: Country
        ]
