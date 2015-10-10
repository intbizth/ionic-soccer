class Personals extends Factory then constructor: (
    NgBackboneCollection, Personal
) ->
    return NgBackboneCollection.extend
        model: Personal
        url: Personal::url
        alias: 'persons'

class Personal extends Factory then constructor: (
    CFG, NgBackboneModel, Helper
) ->
    return NgBackboneModel.extend
        url: CFG.API.getPath 'personals/'
        dataTranformToTeam: ->
            item =
                id: 'id'
                no: 'no'
                fullname: 'fullname'
                image: 'image.media.url'
                position:
                    name: 'position.name'
                    shortName: 'position.short_name'
            item = Helper.traverseProperties @, item
            return item
        dataTranformToDetail: ->
            item =
                id: 'id'
                no: 'no'
                age: 'age'
                fullname: 'fullname'
                firstname: 'firstname'
                lastname: 'lastname'
                nickname: 'nickname'
                birthday: 'birthday'
                image: 'image.media.url'
                bio: 'bio'
                position:
                    name: 'position.name'
                    shortName: 'position.short_name'
                previousClub:
                    id: 'previous_club.id'
                    name: 'previous_club.name'
                    startDate: 'last_club_personal.start_date'
                    signedDate: 'last_club_personal.signed_date'
            item = Helper.traverseProperties @, item
            item.score =
                yellow: 0
                red: 0
                goal: 0
            return item
