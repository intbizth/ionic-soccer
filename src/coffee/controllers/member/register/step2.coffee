class memberRegisterStep2 extends Controller then constructor: (
    $cordovaCamera, $document, $scope, $ionicHistory, $ionicPlatform, $timeout, Chance
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
    element = angular.element(document.querySelector('#photo-user'))
#    element = element.find('photo')

    console.warn 'element', element, $document.find('#photo-user')

    $scope.photo =
        isPhoto: no
        fileUri: null
        openCamera: ->
            $this = @
            console.warn 'openCamera'
            options =
                quality: 100,
                destinationType: Camera.DestinationType.FILE_URI,
                sourceType: Camera.PictureSourceType.CAMERA,
                allowEdit: yes,
                encodingType: Camera.EncodingType.JPEG,
                targetWidth: 200,
                targetHeight: 200,
                popoverOptions: CameraPopoverOptions,
                saveToPhotoAlbum: no,
                correctOrientation: yes

            $cordovaCamera.getPicture(options).then((fileUri) ->
                $this.isPhoto = yes
                $this.fileUri = fileUri

                console.warn 'openCamera', fileUri

                image = document.getElementById('myImage')
#                if '@@environment' == 'dev'
#
#                else

                return
            , (error) ->
                return
            )

    $scope.photo.isPhoto = Chance.bool()

    $scope.data =
        isPass: no
        firstname: ''
        lastname: ''
        fake: ->
            @firstname = Chance.first()
            @lastname = Chance.last()
            @valid()
        reset: ->
            @firstname = @firstname = ''
            @valid()
        valid: ->
            pass = yes
            if not @firstname?.length or not @lastname?.length
                pass = no
            @isPass = pass

    $scope.data.valid()
