class liveMain extends Controller then constructor: (
    $scope, $ionicPlatform, $ionicHistory, $sce, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return
        
    matchEvents = document.getElementById 'match-events'
    matchEventsLine = document.getElementById 'match-events-line'

    $scope.$on('match-events.start', ->
        matchEventsLine.style.height = '0px';
    )

    $scope.$on('match-events.complete', ->
        $timeout(->
            matchEventsLine.style.height = (parseInt(matchEvents.offsetHeight) - 12) + 'px';
        ,500)
    )

    $scope.title = 'Live'
    $scope.matchLabel =
        sections: [],
        next: false
        loadData: ->
            sections = this.fakeSections()
            if sections.length > 0
                sections = [sections[0]]
                if sections[0].items.length > 0
                    sections[0].items = [sections[0].items[0]]
            this.sections = sections
            this.next = false
            console.log('matchLabel:loadData', this.sections.length, JSON.stringify(this.sections), this.next)
            return
        doRefresh: ->
            console.log 'matchLabel:doRefresh'
            $this = this
            $timeout(->
                console.log 'matchLabel:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'matchLabel:loadMore'
            $this = this
            $timeout(->
                console.log 'matchLabel:loadMore2'
                sections = $this.fakeSections()
                for section in sections
                    $this.sections.push section
                if $this.sections.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('matchLabel:loadMore', $this.sections.length, JSON.stringify($this.sections), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                datetime: Chance.date(datetime)
                items: this.fakeItems(datetime)
            return section
        fakeSections: ->
            sections = []
            i = 0
            ii = Und.random(0, 10)
            month = new Date().getMonth()
            year = new Date().getFullYear()
            while i < ii
                datetime =
                    year: year
                    month: month
                section = this.fakeSection(datetime)
                sections.push section
                i++
                month++
                if month > 12
                    month = 1
                    year++
            sections = Und.sortBy(sections, 'items.datetime')
            return sections
            return
        fakeItem: (datetime) ->
            club = Chance.club()
            clubs = [
                logo: './img/logo/match_label@2x.png'
                name: 'Chonburi FC'
                score: Und.random(0, 99)
            ,
                logo: club.image.src
                name: club.name
                score: Und.random(0, 99)
            ]
            item =
                id: Und.random(1, 9999999)
                homeClub: null
                awayClub: null
                datetime: Chance.date(datetime)
                template: Chance.pick(['before', 'after'])
            if Chance.pick([true, false])
                item.homeClub = clubs[0]
                item.awayClub = clubs[1]
            else
                item.homeClub = clubs[1]
                item.awayClub = clubs[0]
            return item
        fakeItems: (datetime) ->
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                item = this.fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

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

    $scope.matchEvents =
        items: [],
        match:
            halftime: false
            end: false
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            console.log('matchEvents:loadData', this.items.length, JSON.stringify(this.items))
            return
        doRefresh: ->
            console.log 'matchEvents:doRefresh'
            $this = this
            $timeout(->
                console.log 'matchEvents:doRefresh2'
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
            $scope.$broadcast 'match-events.start'
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
            items = items.reverse()
            $scope.$broadcast 'match-events.complete'
            return items

    $scope.matchEvents.loadData()

    $scope.doRefresh = ->
        $scope.matchLabel.doRefresh()
        $scope.video.loadData()
        $scope.matchEvents.doRefresh()
