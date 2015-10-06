###*
# Club Model Collection
#
# @author liverbool <phaiboon@intbizth.com>
###
class Clubs extends Factory then constructor: (
    NgBackboneCollection, Club
) ->
    return NgBackboneCollection.extend
        model: Club
        url: Club::url
        alias: 'clubs'

###*
# Club Model
###
class Club extends Factory then constructor: (
    CFG, NgBackboneModel, Country, Und
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'clubs/'

        # Model relations.
        relations: [
            type: 'HasOne'
            key: 'country'
            relatedModel: Country
        ]

        # Define default items
        defaults:
            _links: null

        ###*
        # Get club logo specify the size.
        #
        # @param {string} size The size of image eg. 70x70
        #
        # @return {string} Logo path
        ###
        getLogo: (size) ->
           logo = if Und.isUndefined(size) or Und.isUndefined(@_links['logo_' + size])
               @_links.logo
           else @_links['logo_' + size]

           return Und.result logo, 'href'
