class Images extends Factory then constructor: (
    $ionicPlatform
) ->
    return {
        saveToLibrary: (url, success, error) ->
            try
                console.warn 'saveToLibrary:url', url

                img = new Image()
                img.crossOrigin = ''
                img.src = url

                img.onload = ->
                    canvas = document.createElement 'canvas'
                    canvas.width = img.width
                    canvas.height = img.height
                    context = canvas.getContext '2d'
                    context.drawImage img, 0, 0

                    try
                        window.canvas2ImagePlugin.saveImageDataToLibrary((message) ->
                            success message
                        , (message) ->
                            error message
                        , canvas)
                    catch e
                        error e.message
                img.onerror = (e) ->
                    error 'Image not found.'
            catch e
                error e.message
            return
    }
