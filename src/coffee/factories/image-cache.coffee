class ImageCache extends Factory then constructor: (
    $cordovaFile, $cordovaFileTransfer, $localStorage, md5
) ->
    func =
        path: ''
        includePath: 'images/'
        prefixStore: 'image-'
        expire: 60 * 60 * 24
        init: (callbackSuccess, callbackError) ->
            $this = @

            if ionic.Platform.isAndroid()
                $this.path = cordova.file.cacheDirectory
            else if ionic.Platform.isIOS()
                $this.path = cordova.file.cacheDirectory

            path = $this.path
            directory = $this.includePath
            replace = no

            $cordovaFile.createDir(path, directory, replace).then((success) ->
                $this.removeStore('all')
                callbackSuccess success
            , (error) ->
                $this.remove('all')
                callbackError error
            )
            return
        existDir: (directory, callbackSuccess, callbackError) ->
            $this = @
            path = $this.path

            $cordovaFile.checkDir(path, directory).then((success) ->
                callbackSuccess success
            , (error) ->
                callbackError error
            )
            return
        getDir: ->
            $this = @
            return path = $this.path + $this.includePath
        removeAll: (callbackSuccess, callbackError) ->
            $this = @

            path = $this.path
            directory = $this.includePath
            $cordovaFile.removeRecursively(path, directory).then((success) ->
                $this.init((success) ->
                    return
                , (error) ->
                    return
                )
                callbackSuccess success
            , (error) ->
                $this.init((success) ->
                    return
                , (error) ->
                    return
                )
                callbackError error
            )
            return
        existFile: (url, callbackSuccess, callbackError) ->
            $this = @
            path = $this.getDir()
            file = $this.hashFile url

            $cordovaFile.checkFile(path, file).then((success) ->
                callbackSuccess success
            , (error) ->
                callbackError error
            )
            return
        hashFile: (url) ->
            if url
                filename = md5.createHash(encodeURIComponent(url)) + '.' + url.split('.').pop()
            else
                filename = null
        saveFile: (params, callbackSuccess, callbackError) ->
            $this = @
            targetPath = $this.getDir() + $this.hashFile params.url
            options = {}
            trustHosts = yes

            $this.existFile(params.url, (success) ->
                callbackSuccess success
            , (error) ->
                $cordovaFileTransfer.download(params.url, targetPath, options, trustHosts).then (success) ->
                    key = $this.hashFile params.url
                    value =
                        url: params.url

                    if params.expire
                        value.expire = params.expire

                    $this.createStore key, value
                    callbackSuccess success
                , (error) ->
                    callbackError error
                return
            )
            return
        removeFile: (params, callbackSuccess, callbackError) ->
            $this = @
            path = $this.getDir()
            file = $this.hashFile params.url

            $cordovaFile.removeFile(path, file).then((success) ->
                success = angular.extend params: params, success
                callbackSuccess success
            , (error) ->
                error = angular.extend params: params, error
                callbackError error
            )
            return
        readFile: (params, callbackSuccess, callbackError) ->
            $this = @
            path = $this.getDir()
            file = $this.hashFile params.url

            $cordovaFile.readAsDataURL(path, file).then((success) ->
                success = angular.extend params: params, data: success
                callbackSuccess success
            , (error) ->
                error = angular.extend params: params, error
                callbackError error
            )
            return
        addPrefix: (key) ->
            $this = @
            return $this.prefixStore + key
        checkRegexpStore: (value) ->
            $this = @
            re = new RegExp '^(' + $this.prefixStore + '[a-f0-9]{32}\.(gif|jpg|jpeg|tiff|png))$', 'g'
            return re.test value
        createStore: (key, value) ->
            $this = @
            key = $this.addPrefix key

            if value.expire
                value.expire = $this.getNow() + value.expire
            else
                value.expire = $this.getNow() + $this.expire

            $localStorage[key] = value
            return
        removeStore: (key) ->
            $this = @
            if key == 'all'
                for key, value of $localStorage
                    if $localStorage[key] and $this.checkRegexpStore key
                        delete $localStorage[key]
            else
                if $localStorage[key]
                    delete $localStorage[key]
            return
        getExpireStore: (key) ->
            $this = @
            items = {}
            if key == 'all'
                for key, value of $localStorage
                    if $this.checkRegexpStore(key) and value.expire < $this.getNow()
                        items[key] = value
            else
                if $localStorage[key] and $this.checkRegexpStore(key) and $localStorage[key].expire < $this.getNow()
                    items[key] = $localStorage[key]
            return items
        getNow: ->
            return Math.round((new Date()).getTime() / 1000)
        get: (params, callbackSuccess, callbackError) ->
            $this = @

            $this.remove $this.addPrefix $this.hashFile params.url
            $this.saveFile(params, (success) ->
                success = angular.extend params: params, success
                if '@@environment' == 'dev'
                    $this.readFile(
                        url: success.params.url
                        element: success.params.element
                    , (success2) ->
                        switch success2.params.element[0].tagName
                            when 'DIV' then success2.params.element.css('background-image':'url(' + success2.data + ')')
                            when 'IMG' then success2.params.element.attr 'src', success2.data
                    , (error2) ->
                        switch error2.params.element[0].tagName
                            when 'DIV' then error2.params.element.css('background-image':'url(' + error2.params.url + ')')
                            when 'IMG' then error2.params.element.attr 'src', error2.params.url
                    )
                else
                    switch success.params.element[0].tagName
                        when 'DIV' then success.params.element.css('background-image':'url(' + success.nativeURL + ')')
                        when 'IMG' then success.params.element.attr 'src', success.nativeURL
                callbackSuccess success
            , (error) ->
                error = angular.extend params: params, error
                switch error.params.element[0].tagName
                    when 'DIV' then error.params.element.css('background-image':'url(' + error.params.url + ')')
                    when 'IMG' then error.params.element.attr 'src', error.params.url
                callbackError error
            )
            return
        remove: (key) ->
            $this = @
            for key, value of $this.getExpireStore(key)
                params =
                    url: value.url
                    key: key
                $this.removeFile(params, (success) ->
                    $this.removeStore success.params.key
                    return
                , (error) ->
                    $this.removeStore error.params.key
                    return
                )

    return angular.extend {}, func
