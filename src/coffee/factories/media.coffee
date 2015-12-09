class Media extends Factory then constructor: (
    $q, Chance
) ->
    base64Prefix = 'data:image/jpeg;base64,'
    extension = 'jpeg'

    return {
        get: (args) ->
            deferred = $q.defer()
            camera = if args && args.camera then args.camera else no
            allowEdit = if args && args.allowEdit then args.allowEdit else no
            targetWidth = if args && args.targetWidth then args.targetWidth else 600
            targetHeight = if args && args.targetHeight then args.targetHeight else 600
            saveTopictureAlbum = if args && args.saveTopictureAlbum then args.saveTopictureAlbum else no

            options =
                quality: 100
                destinationType: Camera.DestinationType.DATA_URL
                sourceType: Camera.PictureSourceType.PHOTOLIBRARY
                allowEdit: allowEdit
                encodingType: Camera.EncodingType.JPEG
                targetWidth: targetWidth
                targetHeight: targetHeight
                popoverOptions: CameraPopoverOptions
                saveTopictureAlbum: saveTopictureAlbum
                correctOrientation: yes

            if camera
                options.sourceType = Camera.DestinationType.CAMERA

            navigator.camera.getPicture((imageData) ->
                deferred.resolve base64Prefix + imageData
            , (error) ->
                deferred.reject error
            , options);

            return deferred.promise
        dataStream: (imageData) ->
            stream =
                filename: '-' + Chance.guid() + '.' + extension
                data: []

            chunkSize = 1024 * 1024
            chunkName = new Date().getTime() + stream.filename
            total = Math.ceil imageData.length / chunkSize

            for i in [1..total]
                number = i
                end = chunkSize * number
                end = imageData.length if number is total
                being = chunkSize * i - 1
                being = 0 if i is 1

                stream.data.push(
                    chunkNumber: number
                    chunkContent: imageData.slice being, end
                    totalChunk: total
                    chunkName: chunkName
                    filename: stream.filename
                )

                return if i >= total then stream
    }
