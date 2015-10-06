class Papers extends Factory then constructor: (
    NgBackboneCollection, Paper, Und, Helper
) ->
    dataTranform =
        timelineUpdate:
            news: (models) ->
                items = []
                if Und.isUndefined models
                    return items
                for model in models
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
                    item = Helper.traverseProperties(model, item)
                    items.push item
                return items

    return NgBackboneCollection.extend
        model: Paper
        url: Paper::url
        alias: 'papers'
        dataTranform: dataTranform

class Paper extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'news/'
        relations: []
