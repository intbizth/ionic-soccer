class liveMain extends Controller then constructor: (
<<<<<<< HEAD
    $scope, $ionicHistory
) ->
    $scope.headline = 'Live'
    $scope.dateTop = 'Sep 2015'
    $scope.dateMatch = '1 Sep 2015'
    $scope.score = '1 - 1'
    $scope.teamName1 = 'Chonburi FC'
    $scope.teamName2 = 'Suphanburi FC'
=======
    $scope, $ionicPlatform, $ionicHistory, $sce, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return
    activity = document.getElementById 'activity'
    activityLine = document.getElementById 'activity-line'

    $scope.$on('activity.start', ->
        console.error('activity.start')
        activityLine.style.height = '0px';
    )

    $scope.$on('activity.complete', ->
        $timeout(->
            console.error('activity.complete')
            activityLine.style.height = (parseInt(activity.offsetHeight) - 12) + 'px';
            console.error('activity', activity, activity.offsetHeight)
            console.error('activityLine', activityLine, activityLine.style.height)
        ,500)
    )

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

    $scope.video =
        item: {}
        loadData: ->
            this.item = this.fakeItem();
            console.log('loadData', JSON.stringify(this.item))
            return
        fakeItem: ->
            item =
                url: $sce.trustAsResourceUrl(Chance.pick([
                    'https://www.youtube.com/embed/3iL1Vy671Ds'
                    'https://www.youtube.com/embed/4gkRTil0G6Y'
                    'https://www.youtube.com/embed/8G5UR4KGq4Y'
                    'https://www.youtube.com/embed/OI5X1RGH014'
                    'https://www.youtube.com/embed/Xj3MavBKYnA'
                    'https://www.youtube.com/embed/et9VbbJMHjI'
                    'https://www.youtube.com/embed/r_Woa69OHQg'
                    'https://www.youtube.com/embed/X9zmrh1epik'
                    'https://www.youtube.com/embed/AbIdbr4uxJI'
                    'https://www.youtube.com/embed/_Z-4EbLoeFM'
                    'https://www.youtube.com/embed/ojcQWpU78Q0'
                    'https://www.youtube.com/embed/AbIdbr4uxJI'
                    'https://www.youtube.com/embed/MasAZ5EdEwY'
                ]))
            return item

    $scope.video.loadData()

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
            item =
                id: Und.random(1, 9999999)
            if typeof config isnt 'undefined' and config.start
                item.icon = null
                item.dot = 'large'
                item.name = ''
                item.description = 'เริ่มการแข่งขัน'
                item.align = 'right'
                item.time = '00:00'
            else if typeof config isnt 'undefined' and config.halftime
                item.icon = null
                item.dot = 'halftime'
                item.name = ''
                item.description = 'ครึ่งหลัง'
                item.align = 'right'
                item.time = '45:00'
            else if typeof config isnt 'undefined' and config.end
                minute = Und.random(90, 110)
                second = Chance.second()
                time =  minute + ':' + second
                item.icon = null
                item.dot = 'large'
                item.name = ''
                item.description = 'จบการแข่งขัน'
                item.align = 'right'
                item.time = time
            else
                minute = Chance.minute()
                if Chance.pick([true, false]) then minute += 15
                second = Chance.second()
                if minute < 10 then minute = '0' + minute
                if second < 10 then second = '0' + second
                time =  minute + ':' + second
                if parseInt(minute) >= 45 and parseInt(second) > 1
                    this.match.halftime = true
                item.icon = Chance.pick(['yellow_card', 'red_card', 'yellow_red_card', 'goal'])
                item.dot = 'normal'
                item.name = Chance.name()
                item.description = ''
                item.align = Chance.pick(['left', 'right'])
                item.time = time
            return item
        fakeItems: ->
            $scope.$broadcast 'activity.start'
            items = [this.fakeItem({start: true})]
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                item = this.fakeItem()
                items.push item
                i++
            if this.match.halftime
                items.push this.fakeItem({halftime: true})
            if Chance.pick([true, false])
                this.match.end = true
                items.push this.fakeItem({end: true})
            items = Und.sortBy(items, (value) ->
                return parseFloat value.time
            )
            $scope.$broadcast 'activity.complete'
            console.log('this.match.halftime', this.match.halftime)
            console.log('this.match.end', this.match.end)
            return items

    $scope.activities.loadData()

    $scope.doRefresh = ->
        $scope.matchLabel.doRefresh()
        $scope.video.loadData()
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
>>>>>>> master
