class NewsDetail extends Controller then constructor: (
    $scope, $stateParams, $ionicHistory, $cordovaInAppBrowser, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.news =
        item: {},
        loadData: ->
            @item = @fakeItem()
            console.log('news:loadData', JSON.stringify(@item))
            return
        doRefresh: ->
            console.log 'news:doRefresh'
            $this = @
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            update = Chance.update()
            user = Chance.user()
            item =
                id: Und.random(1, 9999999)
                headline: $stateParams.headline || Chance.sentence()
                image: update.image.src
                datetime: Chance.date()
                creditUrl: Chance.url()
                description: Chance.paragraph(
                    sentences: Und.random(5, 50)
                )
                user:
                    name: user.name
                    photo: user.image.src
            return item

    $scope.news.loadData()

    options =
        location: 'yes'
        clearcache: 'yes'
        toolbar: 'yes'

    $scope.openURL = (url) ->
        $cordovaInAppBrowser.open(url, '_blank', options).then((event) ->
            # success
            return
        ).catch (event) ->
            # error
            return
