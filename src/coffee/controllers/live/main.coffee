class liveMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.title = 'Live'

    $scope.matchLabel =
        item: {}
        loadData: ->
            this.item = this.fakeItem();
            console.log('loadData', JSON.stringify(this.item))
            return
        doRefresh: ->
            console.log 'doRefresh'
            $this = this
            $timeout(->
                console.log 'doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: ->
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
        items: [],
        match:
            halftime: false
            end: false
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            console.log('activities:loadData', this.items.length, JSON.stringify(this.items))
            return
        doRefresh: ->
            console.log 'activities:doRefresh'
            $this = this
            $timeout(->
                console.log 'activities:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem: (config) ->
            minute = Chance.minute()
            if Chance.pick([true, false]) then minute += 15
            second = Chance.second()
            if minute < 10 then minute = '0' + minute
            if second < 10 then second = '0' + second
            time =  minute + ':' + second
            item = null
            if time != '45:00'
                if parseInt(minute) >= 45 and parseInt(second) > 1
                    this.match.halftime = true
                item =
                    id: Und.random(1, 9999999)
                    icon: Chance.pick(['yellow_card', 'red_card', 'yellow_red_card', 'goal'])
                    dot: 'normal'
                    name: Chance.name()
                    description: ''
                    align: Chance.pick(['left', 'right'])
                    time: time
                if typeof config isnt 'undefined' and config.start
                    item.icon = null
                    item.dot = 'large'
                    item.name = ''
                    item.description = 'เริ่มการแข่งขัน'
                    item.align = 'right'
                    item.time = '00:00'
                if typeof config isnt 'undefined' and config.halftime
                    item.icon = null
                    item.dot = 'halftime'
                    item.name = ''
                    item.description = 'ครึ่งหลัง'
                    item.align = 'right'
                    item.time = '45:00'
                if typeof config isnt 'undefined' and config.end
                    minute = Und.random(90, 110)
                    second = Chance.second()
                    time =  minute + ':' + second
                    item.icon = null
                    item.dot = 'large'
                    item.name = ''
                    item.description = 'จบการแข่งขัน'
                    item.align = 'right'
                    item.time = time
            return item
        fakeItems: ->
            items = [this.fakeItem({start: true})]
            if this.match.halftime
                items.push this.fakeItem({halftime: true})
            if Chance.pick([true, false])
                this.match.end = true
                items.push this.fakeItem({end: true})
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                item = this.fakeItem()
                if item != null
                    items.push item
                i++
            items = Und.sortBy(items, (value) ->
                return parseFloat value.time
            )
            return items

    $scope.activities.loadData()

    $scope.doRefresh = ->
        $scope.matchLabel.doRefresh()
        $scope.activities.doRefresh()

    $scope.more = true;
    $scope.loadMore = ->
        $this = this
        $this.doRefresh()
        $this.more = false
        $scope.$broadcast 'scroll.infiniteScrollComplete'

        $timeout(->
            $this.more = true
        , 4000)
