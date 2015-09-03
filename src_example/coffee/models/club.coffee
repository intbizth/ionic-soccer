class Clubs extends Factory then constructor: (
    CFG, NgBackboneCollection, Club
) ->
    return NgBackboneCollection.extend
        model: Club
        url: CFG.API.getPath 'clubs/'

class Club extends Factory then constructor: (
    NgBackboneModel, Und
) ->
    return NgBackboneModel.extend
        defaults:
            _links: null

        getLogo: (size) ->
            logo = if Und.isUndefined(size) or Und.isUndefined(@._links['logo_' + size])
                @._links.logo
            else @._links['logo_' + size]

            return Und.result logo, 'href'
