class liveMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.title = 'Live'

    $scope.matchLabel =
        item : {}
        loadData : ->
            this.item = this.fakeItem();
            console.log('loadData', JSON.stringify(this.item))
            return
        doRefresh : ->
            console.log 'doRefresh'
            $this = this
            $timeout(->
                console.log 'doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem : ->
            item =
                homeClub:
                    logo: './img/live/chonburi@2x.png'
                    name: 'Chonburi FC'
                    score: Und.random(0, 99)
                awayClub:
                    logo: 'https://placeimg.com/80/80/tech?time=' + Chance.timestamp()
                    name: Chance.name()
                    score: Und.random(0, 99)
                datetime: Chance.date()
            return item

    $scope.matchLabel.loadData()

    $scope.activities =
        items : [],
        next : false
        loadData : ->
            items = this.fakeItems()
            this.items =  items
            console.log('activities:loadData', this.items.length, JSON.stringify(this.items))
            return
        doRefresh : ->
            console.log 'activities:doRefresh'
            $this = this
            $timeout(->
                console.log 'activities:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem : ->
            minute = Chance.minute()
            if Chance.pick([true, false]) then minute += 15
            if minute < 10 then minute = '0' + minute
            second = Chance.second()
            if second < 10 then second = '0' + second
            time =  minute + ':' + second
            item =
                id : Chance.integer(
                    min : 1
                    max : 9999999
                )
                icon : Chance.pick([null, 'yellowCard', 'redCard', 'goal'])
                dot : Chance.pick([null, '', '-halftime', '-halftime'])
                name : Chance.name()
                description : ''
                time : time
            return item
        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            items = Und.sortBy(items, 'time')
            return items

    $scope.activities.loadData()

    $scope.doRefresh = ->
        $scope.matchLabel.doRefresh()
        $scope.activities.doRefresh()
