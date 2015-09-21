class Timeline extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.share = ->
        return

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
            clubs = [
                logo: './img/live/chonburi@2x.png'
                name: 'Chonburi FC'
                score: Und.random(0, 99)
            ,
                logo: 'https://placeimg.com/80/80/tech?time=' + Chance.timestamp()
                name: Chance.name()
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

    $scope.timeline =
        isLive : false
        items : []
        next : false
        loadData : ->
            this.isLive = Chance.pick([true, false])
            this.items = this.fakeItems()
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            console.log('timeline:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh : ->
            console.log 'timeline:doRefresh'
            $this = this
            $timeout(->
                console.log 'timeline:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore : ->
            console.log 'timeline:loadMore'
            $this = this
            $timeout(->
                console.log 'timeline:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('timeline:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem : ->
            item =
                id : Chance.integer(
                    min : 1
                    max : 9999999
                )
                template: Chance.pick(['hightlight'])
                datetime: Chance.date()
                images : []
                description: Chance.paragraph(
                    sentences: Und.random(1, 20)
                )
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()

            i = 0
            ii = Und.random(0, 4)
            while i < ii
                item.images.push 'https://placeimg.com/640/640/any?time=' + Chance.hash()
                i++
            return item
        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.timeline.loadData()

    $scope.ticket =
        items : []
        loadData : ->
            items = this.fakeItems()
            i = 1
            for item in items
                if i == 1
                    item.class = 'first'
                else if i == 2
                    item.class = 'second'
                else if i == 3
                    item.class = 'third'
                i++
                if i > 3
                    i = 1

            this.items =  items
            console.log('ticket:loadData', this.items.length, JSON.stringify(this.items))
            return
        fakeItem : ->
            item =
                id : Chance.integer(
                    min : 1
                    max : 9999999
                )
                seats : []
                textSeats : ''
                count : Und.random(0, 9999)

            i = 0
            ii = Und.random(1, 20)
            while i < ii
                item.seats.push Chance.character(
                    alpha: true
                    casing: 'upper'
                )
                i++

            item.seats = Und.uniq item.seats
            item.seats.sort()
            item.textSeats = item.seats.join ', '
            return item
        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.ticket.loadData()

    $scope.doRefresh = ->
        $scope.matchLabel.loadData()
        $scope.timeline.doRefresh()
        return

    $scope.loadMore = ->
        $scope.timeline.loadMore()
        return
