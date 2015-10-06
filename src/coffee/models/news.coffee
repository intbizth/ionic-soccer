class NewsStore extends Factory then constructor: (
    NgBackboneCollection, News, Und, Helper
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
        model: News
        url: News::url
        alias: 'news'
        dataTranform: dataTranform

class News extends Factory then constructor: (
    CFG, NgBackboneModel
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'news/'
