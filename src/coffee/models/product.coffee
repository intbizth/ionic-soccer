#class Products extends Factory then constructor: (
#    NgBackboneCollection, Product
#) ->
#    return NgBackboneCollection.extend
#        model: Product
#        url: Product::url
#        alias: 'products'
#
#class Product extends Factory then constructor: (
#    CFG, NgBackboneModel, Helper
#) ->
#    return NgBackboneModel.extend
#        url: CFG.API.getPath 'product/'
#        relations: []
#        dataTranformToFanzone: ->
#            item =
#                id: 'id'
#                name: 'name'
#                price: 'price'
#                image: 'image.media.url'
#            return Helper.traverseProperties @, item
#        dataTranformToDetail: ->
#            item =
#                id: 'id'
#                name: 'name'
#                model: 'model'
#                description: 'description'
#                price: 'price'
#                moreDescription: 'more_description'
#                image: 'image.media.url'
#            return Helper.traverseProperties @, item
