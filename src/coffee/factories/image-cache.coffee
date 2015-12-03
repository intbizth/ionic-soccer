class ImageCache extends Factory then constructor: (
    $cordovaFile, $cordovaFileTransfer, $localStorage, $q, md5
) ->
    func =
        path: ''
        includePath: 'images/'
        prefixStore: 'image-'
        expire: 60 * 60 * 24
        init: ->
            $this = @
            deferred = $q.defer()

            if ionic.Platform.isAndroid()
                $this.path = cordova.file.cacheDirectory
            else if ionic.Platform.isIOS()
                $this.path = cordova.file.cacheDirectory

            path = $this.path
            directory = $this.includePath
            replace = no

            $cordovaFile.createDir(path, directory, replace).then((success) ->
                $this.removeStore('all')
                deferred.resolve success
            , (error) ->
                $this.remove('all')
                deferred.reject error
            )
            return deferred.promise
        existDir: (directory) ->
            $this = @
            deferred = $q.defer()
            path = $this.path

            $cordovaFile.checkDir(path, directory).then((success) ->
                deferred.resolve success
            , (error) ->
                deferred.reject error
            )
            return deferred.promise
        getDir: ->
            $this = @
            return path = $this.path + $this.includePath
        removeAll: ->
            $this = @
            deferred = $q.defer()

            path = $this.path
            directory = $this.includePath
            $cordovaFile.removeRecursively(path, directory).then((success) ->
                $this.init()
                deferred.resolve success
            , (error) ->
                $this.init()
                deferred.reject error
            )
            return deferred.promise
        existFile: (url) ->
            $this = @
            deferred = $q.defer()
            path = $this.getDir()
            file = $this.hashFile url

            $cordovaFile.checkFile(path, file).then((success) ->
                deferred.resolve success
            , (error) ->
                deferred.reject error
            )
            return deferred.promise
        hashFile: (url) ->
            if url
                filename = md5.createHash(encodeURIComponent(url)) + '.' + url.split('.').pop()
            else
                filename = null
        saveFile: (params) ->
            $this = @
            deferred = $q.defer()
            targetPath = $this.getDir() + $this.hashFile params.url
            options = {}
            trustHosts = yes

            promise = $this.existFile params.url
            promise.then((success) ->
                deferred.resolve success
            , (error) ->
                $cordovaFileTransfer.download(params.url, targetPath, options, trustHosts).then (success) ->
                    key = $this.hashFile params.url
                    value =
                        url: params.url

                    if params.expire
                        value.expire = params.expire

                    $this.createStore key, value
                    deferred.resolve success
                , (error) ->
                    deferred.reject error
            )
            return deferred.promise
        removeFile: (params) ->
            $this = @
            deferred = $q.defer()
            path = $this.getDir()
            file = $this.hashFile params.url

            $cordovaFile.removeFile(path, file).then((success) ->
                success = angular.extend params: params, success
                deferred.resolve success
            , (error) ->
                error = angular.extend params: params, error
                deferred.reject error
            )
            return deferred.promise
        readFile: (params) ->
            $this = @
            deferred = $q.defer()
            path = $this.getDir()
            file = $this.hashFile params.url

            $cordovaFile.readAsDataURL(path, file).then((success) ->
                success = angular.extend params: params, data: success
                deferred.resolve success
            , (error) ->
                error = angular.extend params: params, error
                deferred.reject error
            )
            return deferred.promise
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
        get: (params) ->
            $this = @
            deferred = $q.defer()

            $this.remove $this.addPrefix $this.hashFile params.url

            promise = $this.saveFile params
            promise.then((success) ->
                success = angular.extend params: params, success
                if '@@environment' == 'dev'
                    promise2 = $this.readFile(
                        url: success.params.url
                        element: success.params.element
                    )
                    promise2.then((success2) ->
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
                deferred.resolve success
            , (error) ->
                error = angular.extend params: params, error
                switch error.params.element[0].tagName
                    when 'DIV' then error.params.element.css('background-image':'url(' + error.params.url + ')')
                    when 'IMG' then error.params.element.attr 'src', error.params.url
                deferred.reject error
            )
            return deferred.promise
        remove: (key) ->
            $this = @
            for key, value of $this.getExpireStore(key)
                params =
                    url: value.url
                    key: key

                promise = $this.removeFile params
                promise.then((success) ->
                    $this.removeStore success.params.key
                , (error) ->
                    $this.removeStore error.params.key
                )

    return angular.extend {}, func
