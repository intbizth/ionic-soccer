class MatchView extends Controller then constructor: (
    $scope, $timeout, Und, Chance
) ->
    $scope.data =
        doRefresh: ->
            $scope.matchLabel.doRefresh()
            $scope.matchEvents.doRefresh()
            return

    $scope.matchLabel =
        sections: []
        loadData: ->
            sections = @fakeSections()
            if sections.length > 0
                sections = [sections[0]]
                if sections[0].items.length > 0
                    sections[0].items = [sections[0].items[0]]
            @sections = sections
            console.log('matchLabel:loadData', @sections.length, JSON.stringify(@sections))
            return
        doRefresh: ->
            console.log 'matchLabel:doRefresh'
            $this = @
            $timeout(->
                console.log 'matchLabel:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'matchLabel:loadMore'
            $this = @
            $timeout(->
                console.log 'matchLabel:loadMore2'
                sections = $this.fakeSections()
                for section in sections
                    $this.sections.push section
                console.log('matchLabel:loadMore', $this.sections.length, JSON.stringify($this.sections))
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                datetime: Chance.date(datetime)
                items: @fakeItems(datetime)
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
                section = @fakeSection(datetime)
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
            if Chance.bool()
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
                item = @fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.matchLabel.loadData()

    $scope.matchEvents =
        items: [],
        match:
            halftime: no
            end: no
        loadData: ->
            items = @fakeItems()
            @items =  items
            console.log('matchEvents:loadData', @items.length, JSON.stringify(@items))
            return
        doRefresh: ->
            console.log 'matchEvents:doRefresh'
            $this = @
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
                if Chance.bool() then minute += 15
                second = Chance.second()
                if minute < 10 then minute = '0' + minute
                if second < 10 then second = '0' + second
                time =  minute + ':' + second
                if parseInt(minute) >= 45 and parseInt(second) > 1
                    @match.halftime = yes
                item.icon = Chance.pick(['yellow_card', 'red_card', 'yellow_red_card', 'goal'])
                item.dot = 'normal'
                item.name = Chance.name()
                item.description = ''
                item.align = Chance.pick(['left', 'right'])
                item.time = time
            return item
        fakeItems: ->
            items = [@fakeItem(start: yes)]
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                item = @fakeItem()
                items.push item
                i++
            if this.match.halftime
                items.push @fakeItem(halftime: yes)
            if Chance.bool()
                @match.end = yes
                items.push @fakeItem(end: yes)
            items = Und.sortBy(items, (value) ->
                return parseFloat value.time
            )
            items = items.reverse()
            return items

    $scope.matchEvents.loadData()
