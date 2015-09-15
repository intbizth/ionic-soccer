class NewsDetail extends Controller then constructor: (
    $scope, $stateParams, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.news =
        item : {},
        loadData : ->
            item = this.fakeItem()
            this.item =  item
            console.log('news:loadData', JSON.stringify(this.item))
            return
        doRefresh : ->
            console.log 'news:doRefresh'
            $this = this
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem : ->
            item =
                id : Chance.integer(
                    min : 1
                    max : 9999999
                )
                headline : $stateParams.headline || Chance.sentence()
                image : 'https://placeimg.com/640/292/any?time=' + Chance.hash()
                datetime : Chance.date()
                creditUrl : Chance.url()
                description : Chance.paragraph(
                    sentences: Und.random(5, 50)
                )
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()

            return item

    $scope.news.loadData()
