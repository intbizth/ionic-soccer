class rankingDetail extends Controller then constructor: (
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
            , 1000)
            return
        fakeItem: ->
            item =
                result:
                    homeScore: Und.random(1, 100)
                    homeRound: Und.random(1, 100)
                    withdrawScore: Und.random(1, 100)
                    withdrawRound: Und.random(1, 100)
                    awayScore: Und.random(1, 100)
                    awayRound: Und.random(1, 100)
                    volume: Und.random(1, 100)
                    right: Und.random(1, 100)
                    wrong: Und.random(1, 100)
                    point: Und.random(1, 100)
                    accuracy: Und.random(1, 100)
                score:
                    volume: Und.random(1, 100)
                    right: Und.random(1, 100)
                    almost: Und.random(1, 100)
                    wrong: Und.random(1, 100)
                    point: Und.random(1, 100)
                    accuracy: Und.random(1, 100)
                    total: Und.random(1, 100)
            return item

    $scope.months =
        item: {},
        loadData: ->
            item = this.fakeItem()
            this.item =  item
            console.log('months:loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'months:doRefresh'
            $this = this
            $timeout(->
                console.log 'months:deRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 1000)
            return
        fakeItem: ->
            item =
                result:
                    homeScore: Und.random(1, 100)
                    homeRound: Und.random(1, 100)
                    withdrawScore: Und.random(1, 100)
                    withdrawRound: Und.random(1, 100)
                    awayScore: Und.random(1, 100)
                    awayRound: Und.random(1, 100)
                    volume: Und.random(1, 100)
                    right: Und.random(1, 100)
                    wrong: Und.random(1, 100)
                    point: Und.random(1, 100)
                score:
                    volume: Und.random(1, 100)
                    right: Und.random(1, 100)
                    almost: Und.random(1, 100)
                    wrong: Und.random(1, 100)
                    point: Und.random(1, 100)
                    total: Und.random(1, 100)
            return item

    $scope.lasts =
        items: []
        next: no
        loadData: ->
            @items = @fakeItems()
            console.log('lasts:loadData', JSON.stringify(@items))
            return
        doRefresh: ->
            console.log 'lasts:doRefresh'
            $this = @
            $timeout(->
                console.log 'lasts:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 1000)
            return
        fakeItem: ->
            item =
                teamHome:
                    name: Chance.first()
                    score: Und.random(0, 10)
                teamAway:
                    name: Chance.first()
                    score: Und.random(0, 10)
                result:
                    datetime: Chance.date(string: yes, american: no);
                    point: Und.random(0, 5)
                    total: Und.random(0, 100)
                real:
                    total: Und.random(0, 100)
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 5)
            while i < ii
                items.push @fakeItem()
                i++
            return items


    $scope.ranking.loadData()
    $scope.seasons.loadData()
    $scope.months.loadData()
    $scope.lasts.loadData()

    $scope.data =
        doRefresh: ->
            $scope.ranking.doRefresh()
            $scope.seasons.doRefresh()
            $scope.months.doRefresh()
            $scope.lasts.doRefresh()
            return

#    $scope.refresh = ->
#        $scope.ranking.refresh()
#        $scope.seasons.refresh()
#        $scope.months.refresh()
#        $scope.lasts.refresh()
#        return

