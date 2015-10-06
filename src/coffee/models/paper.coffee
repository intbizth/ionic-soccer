class Papers extends Factory then constructor: (
    NgBackboneCollection, Paper
) ->
    return NgBackboneCollection.extend
        model: Paper
        url: Paper::url
        alias: 'papers'

class Paper extends Factory then constructor: (
    CFG, NgBackboneModel, Helper
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'news/'
        relations: []
        dataTranformToUpdate: ->
            item =
                id: 'id'
                headline: 'headline'
                subhead: 'subhead'
                description: 'description'
                highlight: 'highlight'
                content: 'content'
                creditUrl: 'credit_url'
                image: 'image'
                cover: 'cover'
                user:
                    id: 'user.id'
                    displayname: 'user.displayname'
                    profilePicture: 'user.profile_picture'
                publishedDate: 'published_date'
            return Helper.traverseProperties @, item
