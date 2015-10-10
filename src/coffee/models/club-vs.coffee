###*
# Statistic Model Collection
#
# @author beer <kannipa@intbizth.com>
###
class Statistics extends Factory then constructor: (
    NgBackboneCollection, Statistic
) ->
    return NgBackboneCollection.extend
        model: Statistic
        url: Statistic::url + 'latest'

###*
# News Model
###
class Statistic extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'matches/latest/{clubId1}vs{clubId2}'
