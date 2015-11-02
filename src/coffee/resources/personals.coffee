class Personals extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('personals'), {}, {
        getClubMe:
            url: CFG.API.getPath('personals/club/' + CFG.clubId)
            method: 'GET'
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
                fields =
                    limit: 'limit'
                    page: 'page'
                    pages: 'pages'
                    total: 'total'
                    items: '_embedded.items'
                data = Helper.traverseProperties data, fields
                data.items = Und.map data.items, (item) ->
                    fields =
                        id: 'id'
                        no: 'no'
                        fullname: 'fullname'
                        image: 'image.media.url'
                        position:
                            name: 'position.name'
                            shortName: 'position.short_name'
                    return Helper.traverseProperties item, fields
                if data.page < data.pages
                    data.next = data.page + 1
                return data
            timeout: timeout
        getId:
            method: 'GET'
            params:
                id: '@id'
            url: CFG.API.getPath('personals/:id')
            transformResponse: (data, headersGetter) ->
                try
                    data = angular.fromJson(data)
                catch
                    data = {}
                fields =
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
                data = Helper.traverseProperties data, fields
                data.score =
                    yellow: 0
                    red: 0
                    goal: 0
                return data
            timeout: timeout
    })

    return resource
