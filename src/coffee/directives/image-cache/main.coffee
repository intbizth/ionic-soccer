class ImageCache extends Directive then constructor: (
    ImageCache
) ->
    return {
        restrict: 'A'
        scope:
            expire: '@'
        link: (scope, element, attrs) ->
            if attrs.imageCache
                params =
                    url: attrs.imageCache
                    element: element

                if attrs.expire
                    params.expire = parseInt attrs.expire

                newImage = ImageCache.get(params, (success) ->
                    return
                , (error) ->
                    return
                )

            return
    }
