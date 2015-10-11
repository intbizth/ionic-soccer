class MicroChats extends Factory then constructor: (
    NgBackboneCollection, MicroChat
) ->
    return NgBackboneCollection.extend
        model: MicroChat
        url: MicroChat::url
        alias: 'microchats'

class MicroChat extends Factory then constructor: (
    CFG, NgBackboneModel, Helper
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'micro-chats/'
        relations: []
        dataTranformToTimeline: ->
            item =
                id: 'id'
                message: 'message'
                image: 'image'
                user:
                    id: 'user.id'
                    displayname: 'user.displayname'
                    profilePicture: 'user.profile_picture'
                publishedDate: 'published_date'
            return Helper.traverseProperties @, item
