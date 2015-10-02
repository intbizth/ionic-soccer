###*
# News Model Collection
#
# @author beer <kannipa@intbizth.com>
###
class NewsStore extends Factory then constructor: (
    NgBackboneCollection, News
) ->
    return NgBackboneCollection.extend
        model: News
        url: News::url + 'latest'

###*
# News Model
###
class News extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'news/'
