class GamesDetailLive extends Controller then constructor: (
    $rootScope, $scope, $ionicHistory, $ionicLoading, $timeout, GoogleAnalytics, Matches, Und, Chance, $ionicPlatform
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'games_live'

    $scope.timeRemain = Und.random(0, 90)

    $scope.data =
        next: no
        doRefresh: ->
            $scope.matchLabel.doRefresh()
            return
        loadMore: ->
            return

    $scope.streaming =
        item: url: null

    $scope.matchLabel =
        sections: [],
        next: false
        loadData: ->
            sections = this.fakeSections()
            this.sections = sections
            this.next = Chance.pick([true, false])
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
            , 1000)
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
            , 1000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                name: 'Thai Premier League'
                logo: 'http://demo.balltoro.com/media/image/cms/medias/tpl.jpg'
                datetime: Chance.date(datetime)
                items: this.fakeItems(datetime)
            return section
        fakeSections: ->
            sections = []
            i = 0
            ii = 1
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
                isLive: Chance.bool({
                    likelihood: 30
                })
                endMatch: false
                progressData: []
                leftValue: null
                rightValue: null
                handicap: chance.floating({min: -3, max: 3, fixed: 2})
                template: Chance.pick(['before'])
            if item.isLive == true || item.isLive == false
                randomValue = Und.random(1, 100)
                leftWon = null
                rightWon = null
                item.leftValue = 100 - randomValue
                item.rightValue = randomValue
                if item.leftValue > item.rightValue
                    leftWon = yes
                    rightWon = no
                else
                    leftWon = no
                    rightWon = yes

                item.progressData = [
                    { value:item.leftValue , color:'#FF3B30', won:leftWon, status:'-left' }
                    { value:item.rightValue , color:'#FAAF40', won:rightWon, status:'-right' }
                ]
            if item.isLive == false
                item.endMatch = Chance.bool({
                    likelihood: 30
                })
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
            ii = Und.random(1, 1)
            while i < ii
                item = this.fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.matchLabel.loadData()

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
                item.endmatch = true
            else
                minute = Chance.minute()
                if Chance.pick([true, false]) then minute += 15
                second = Chance.second()
                if minute < 10 then minute = '0' + minute
                if second < 10 then second = '0' + second
                time =  minute + ':' + second
                if parseInt(minute) >= 45 and parseInt(second) > 1
                    this.match.halftime = true
                item.icon = Chance.pick(['yellow_card', 'red_card', 'goal'])
                item.dot = 'normal'
                item.name = Chance.name()
                item.description = ''
                item.align = Chance.pick(['left', 'right'])
                item.time = time
            return item
        fakeItems: ->
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
            return items

    $scope.matchEvents.loadData()
