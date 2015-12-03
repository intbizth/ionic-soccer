class MemberPictureMain extends Controller then constructor: (
    $cordovaCamera, $document, $ionicHistory, $ionicLoading, $q, $rootScope, $scope, md5, Users
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.errorMessage = ''
    $scope.loadData = ->
        $scope.profile.setDefault()
        if $rootScope.user.profilePicture
            $scope.profile.item.picture = $rootScope.user.profilePicture
            $scope.media.state = 'load'
            $scope.media.isPicture = yes

    $scope.profile =
        item: {}
        itemDefault:
            picture: './img/member/picture@2x.png'
        setDefault: ->
            @item = angular.copy @itemDefault
        uploadPicture: (imageData) ->
            $this = @
            deferred = $q.defer()

            filedata = angular.copy $rootScope.user
            filedata2 =
                time: (new Date()).getTime()

            angular.extend filedata, filedata2

            filename =  '_' + $rootScope.user.usernameCanonical + '_' + md5.createHash(angular.toJson(filedata)).substr(0, 6)
            filename += '.jpeg'

            chunkSize = 1024 * 1024
            chunkName = new Date().getTime() + filename
            total = Math.ceil imageData.length / chunkSize

            for i in [0..total]
                number = i + 1
                end = chunkSize * number
                end = imageData.length if number is total
                being = chunkSize * i
                being = 0 if i is 0
                return if i >= total then deferred.promise

                users = new Users(
                    chunkNumber: number
                    chunkContent: imageData.slice being, end
                    totalChunk: total
                    chunkName: chunkName
                    filename: filename
                )

                users.$uploadPicture({}
                , (success) ->
                    if success.url
                        deferred.resolve success
                , (error) ->
                    deferred.reject error
                )
        removePicture: ->
            $ionicLoading.show()
            users = new Users()
            users.$removePicture({})

    $scope.media =
        state: 'blank'
        isPicture: no
        imageData: null
        imageDataPrefix: 'data:image/jpeg;base64,'
        element: angular.element $document[0].querySelector '.member-form .form img.picture'
        get: (args) ->
            $this = @
            camera = if args && args.camera then args.camera else no
            options =
                quality: 100
                destinationType: Camera.DestinationType.DATA_URL
                sourceType: Camera.PictureSourceType.PHOTOLIBRARY
                allowEdit: yes
                encodingType: Camera.EncodingType.JPEG
                targetWidth: 400
                targetHeight: 400
                popoverOptions: CameraPopoverOptions,
                saveTopictureAlbum: no
                correctOrientation: yes

            if camera
                options.sourceType = Camera.DestinationType.CAMERA

            $cordovaCamera.getPicture(options).then((imageData) ->
                $this.state = 'new'
                $this.isPicture = yes
                $this.imageData = $this.imageDataPrefix + imageData
                $scope.profile.item.picture = $this.imageData

                $ionicLoading.show()

                promise = $scope.profile.uploadPicture $this.imageData

                promise.then((success) ->
                    $ionicLoading.hide()
                    $rootScope.$emit 'profile:pictureChange', success.url
                    $scope.back()
                , (error) ->
                    $ionicLoading.hide()
                    $scope.errorMessage = error.statusText
                )
                return
            , (error) ->
                return
            )

            $cordovaCamera.cleanup().then(->
                return
            )
        openGallery: ->
            @get()
            $scope.errorMessage = ''
        openCamera: ->
            @get(camera: yes)
            $scope.errorMessage = ''
        remove: ->
            $this = @
            $scope.errorMessage = ''

            promise = $scope.profile.removePicture()
            promise.then((success) ->
                $this.state = 'blank'
                $this.isPicture = no
                $this.imageData = null
                $ionicLoading.hide()
                $rootScope.$emit 'profile:pictureChange', null
                $scope.back()
            , (error) ->
                $ionicLoading.hide()
                $scope.errorMessage = error.statusText
            )

    $scope.loadData()
