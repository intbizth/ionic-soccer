class rankingPlayerDetail extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.ranking =
        item: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('ranking:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'ranking:doRefresh'
            $this = this
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                id: Und.random(1, 9999999)
                name: profile.name
                photo: profile.image.src
                prediction: Und.random(1, 9999999)
                score: Und.random(1, 9999999)
                player: Und.random(1, 9999999)
            return item

    $scope.seasons =
        item: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('seasons:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'seasons:doRefresh'
            $this = this
            $timeout(->
                console.log 'seasons:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
            profile = Chance.profile()
            item =
                predict: Und.random(0, 999)
                right: Und.random(0, 999)
                sum: Und.random(0, 999)
                accuracy: Chance.floating({min: 0, max: 100, fixed: 2});
            return item

    $scope.ranking.loadData()
    $scope.seasons.loadData()

    $scope.data =
        doRefresh: ->
            $scope.ranking.doRefresh()
            $scope.seasons.doRefresh()
