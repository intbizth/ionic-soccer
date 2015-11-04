class clubs extends Factory then constructor: (
    $resource, CFG, Helper, Und
) ->
    timeout = 20000

    resource = $resource(CFG.API.getPath('clubs'), {}, {
        getMe:
            url: CFG.API.getPath('clubs/' + CFG.clubId)
            method: 'GET'
            responseType: 'json'
            transformResponse: (data, headersGetter) ->
                fields =
                    id: 'id'
                    name: 'name'
                    shortName: 'short_name'
                    signatureName: 'signature_name'
                    estYear: 'est_year'
                    logo: 'logo.media.url'
                    stadiumCapacity: 'stadium_capacity'
                    stadiumImage: 'stadium_image.media.url'
                    website: 'website'
                    email: 'email'
                    location: 'location'
                    country:
                        id: 'country.id'
                        name: 'country.name'
                    clubClass:
                        id: 'club_class.id'
                        name: 'club_class.name'
                return Helper.traverseProperties data, fields
            timeout: timeout
    })

    return resource
