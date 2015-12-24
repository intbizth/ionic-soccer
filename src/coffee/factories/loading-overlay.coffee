class LoadingOverlay extends Factory then constructor: (
    $document, $rootScope, $timeout
) ->
    getElement = (id) ->
        return angular.element $document[0].querySelector '.loading-overlay-id-' + id

    @show = (id) ->
        _show = ->
            element = getElement id
            element.removeClass 'loading-overlay-hide'
            element.addClass 'loading-overlay-show'

        ionic.DomUtil.ready ->
            if $rootScope.isAndroid
                $timeout(->
                    _show()
                , 200)
            else if $rootScope.isIOS
                _show()
        return

    @hide = (id) ->
        _hide = ->
            element = getElement id
            element.removeClass 'loading-overlay-show'
            element.addClass 'loading-overlay-hide'

        ionic.DomUtil.ready ->
            if $rootScope.isAndroid
                $timeout(->
                    _hide()
                , 200)
            else if $rootScope.isIOS
                _hide()
        return
    return @
