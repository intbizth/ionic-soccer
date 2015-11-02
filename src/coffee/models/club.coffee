#class Clubs extends Factory then constructor: (
#    NgBackboneCollection, Club
#) ->
#    return NgBackboneCollection.extend
#        model: Club
#        url: Club::url
#        alias: 'Clubs'
#
#class Club extends Factory then constructor: (
#    CFG, NgBackboneModel, Helper
#) ->
#    return NgBackboneModel.extend
#        url: CFG.API.getPath 'clubs/'
#        dataTranformToInfo: ->
#            item =
#                id: 'id'
#                name: 'name'
#                shortName: 'short_name'
#                signatureName: 'signature_name'
#                estYear: 'est_year'
#                logo: 'logo.media.url'
#                stadiumCapacity: 'stadium_capacity'
#                stadiumImage: 'stadium_image.media.url'
#                website: 'website'
#                email: 'email'
#                location: 'location'
#                country:
#                    id: 'country.id'
#                    name: 'country.name'
#                clubClass:
#                    id: 'club_class.id'
#                    name: 'club_class.name'
#            return Helper.traverseProperties @, item