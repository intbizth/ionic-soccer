class memberRegisterStep2 extends Controller then constructor: (
    $cordovaCamera, $scope, $ionicHistory, $ionicPlatform, $timeout, Chance
) ->
    $ionicPlatform.onHardwareBackButton(->
        $scope.back()
    )

    $scope.back = ->
        $ionicHistory.goBack -1

        $timeout(->
            $scope.data.reset()
        , 200)
        return

    $scope.photo =
        isPhoto: no
        fileUri: null
        base64: null
        element: angular.element(document.querySelector('#photo-user'))
        getPicture: (args) ->
            $this = @
            camera = if args && args.camera then args.camera else no
            options =
                quality: 100,
                destinationType: Camera.DestinationType.FILE_URI,
                sourceType: Camera.PictureSourceType.PHOTOLIBRARY,
                allowEdit: yes,
                encodingType: Camera.EncodingType.JPEG,
                targetWidth: 200,
                targetHeight: 200,
                popoverOptions: CameraPopoverOptions,
                saveToPhotoAlbum: no,
                correctOrientation: yes

            if '@@environment' == 'dev'
                options.destinationType = Camera.DestinationType.DATA_URL

            if camera
                options.sourceType = Camera.DestinationType.CAMERA

            $cordovaCamera.getPicture(options).then((imageData) ->
                $this.isPhoto = yes
                if '@@environment' == 'dev'
                    $this.base64 = imageData
                    $this.element.attr 'src', 'data:image/jpeg;base64,' + $this.base64
                    $this.element.removeAttr 'srcset'
                else
                    $this.fileUri = imageData
                    $this.element.attr 'src', $this.fileUri
                    $this.element.removeAttr 'srcset'
                return
            , (error) ->
                return
            )

            $cordovaCamera.cleanup().then(->
                return
            )
        openGallery: ->
            @getPicture()
        openCamera: ->
            @getPicture(camera: true)
        remove: ->
            @isPhoto = no
            @fileUri = null
            @base64 = null
            @element.attr 'src', './img/member/profile.png'
            @element.attr 'srcset', './img/member/profile@2x.png 2x'
            return

    $scope.data =
        isPass: no
        firstname: ''
        lastname: ''
        birthday: ''
        fake: ->
            @firstname = Chance.first()
            @lastname = Chance.last()
            @birthday = Chance.birthday().toISOString().slice(0, 10)
            @valid()
        reset: ->
            @firstname = @lastname = @birthday = ''
            @valid()
        valid: ->
            pass = yes
            if not @firstname?.length or not @lastname?.length
                pass = no
            @isPass = pass

    $scope.data.valid()
