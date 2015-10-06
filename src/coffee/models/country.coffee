###*
# Country Model Collection
#
# @author liverbool <phaiboon@intbizth.com>
###
class Countries extends Factory then constructor: (
    NgBackboneCollection, Country
) ->
    return NgBackboneCollection.extend
        model: Country
        url: Country::url
        alias: 'countries'

###*
# Country Model
###
class Country extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'countries/'
