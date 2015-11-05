class ImageCache extends Directive then constructor: (
    ImageCache
) ->
    return {
        restrict: 'A'
        scope:
            expire: '@'
        link: (scope, element, attrs) ->
            console.warn scope, element, attrs

            image = if attrs.imageCache then attrs.imageCache else ''
            expire = if attrs.expire then parseInt attrs.expire else 0

            imageHash = ImageCache.hash image

            if element[0].tagName == 'DIV'
                element.css('background-image':'url(' + image + ')')
            else if element[0].tagName == 'IMG'
                element.attr 'src', image
            else

            console.warn element
            console.warn image, imageHash, expire
            return
    }
