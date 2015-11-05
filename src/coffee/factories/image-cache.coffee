class ImageCache extends Factory then constructor: (
    $localStorage, md5
) ->
    return {
        hash: (value) ->
            return if value then md5.createHash(value) else null
    }
