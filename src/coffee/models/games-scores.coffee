#class GamesScores extends Factory then constructor: (
#    NgBackboneCollection, GamesScore
#) ->
#    return NgBackboneCollection.extend
#        model: GamesScore
#        url: GamesScore::url
#        alias: 'gamesScores'
#
#class GamesScore extends Factory then constructor: (
#    CFG, NgBackboneModel, Helper
#) ->
#    return NgBackboneModel.extend
#        url: CFG.API.getPath 'games-scores/'
#        dataTranformToGamesScore: ->
#            item =
#                id: ''
#                profilePicture: 'user.profile_picture'
#                displayName: 'user.displayname'
#                times: 'times'
#                points: 'points'
#            item = Helper.traverseProperties @, item
#            return item
