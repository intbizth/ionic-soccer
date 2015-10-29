class Wallpapers extends Factory then constructor: (
    NgBackboneCollection, Wallpaper
) ->
    return NgBackboneCollection.extend
        model: Wallpaper
        url: Wallpaper::url
        alias: 'wallpapers'

class Wallpaper extends Factory then constructor: (
    CFG, NgBackboneModel, Helper
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'wallpaper/'
        relations: []
        dataTranformToFanzone: ->
            item =
                id: 'id'
                name: 'name'
                image: 'image.media.url'
            return Helper.traverseProperties @, item
