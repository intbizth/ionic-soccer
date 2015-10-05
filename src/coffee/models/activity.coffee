###*
# Country Model Collection
#
# @author liverbool <phaiboon@intbizth.com>
###
class Activities extends Factory then constructor: (
    NgBackboneCollection, Activity
) ->
    return NgBackboneCollection.extend
        model: Activity
        alias: 'activities'

###*
# Country Model
###
class Activity extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend {}
