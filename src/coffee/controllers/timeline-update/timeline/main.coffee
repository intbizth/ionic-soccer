class Timeline extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.data =
        next: no
        doRefresh: ->
            $scope.matchLabel.loadData()
            $scope.timeline.doRefresh()
            return
        loadMore: ->
            $scope.timeline.loadMore()
            return

    $scope.share = ->
        return

    $scope.matchLabel =
        sections: [],
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

    $scope.timeline =
        isLive: no
        items: []
        next: no
        loadData: ->
            @.isLive = Chance.bool()
            @.items = @fakeItems()
            $scope.data.next = @next = if @items.length > 0 then Chance.bool() else no
            console.log('timeline:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            console.log 'timeline:doRefresh'
            $this = @
            $timeout(->
                console.log 'timeline:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'timeline:loadMore'
            $this = @
            $timeout(->
                console.log 'timeline:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                $scope.data.next = $this.next = if $this.items.length > 0 then Chance.bool() else no
                console.log('timeline:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            user = Chance.user()
            item =
                id: Und.random(1, 9999999)
                template: Chance.pick(['hightlight'])
                datetime: Chance.date()
                images: []
                description: Chance.paragraph(
                    sentences: Und.random(1, 20)
                )
                user:
                    name: user.name
                    photo: user.image.src
            i = 0
            ii = Und.random(0, 4)
            while i < ii
                timeline = Chance.timeline()
                item.images.push timeline.image.src
                i++
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push @fakeItem()
                i++
            return items

    $scope.timeline.loadData()

    $scope.ticket =
        items: []
        loadData: ->
            items = @fakeItems()
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

            @items =  items
            console.log('ticket:loadData', @items.length, JSON.stringify(@items))
            return
        fakeItem: ->
            item =
                id: Und.random(1, 9999999)
                seats: []
                textSeats: ''
                count: Und.random(0, 9999)

            i = 0
            ii = Und.random(1, 20)
            while i < ii
                item.seats.push Chance.character(
                    alpha: yes
                    casing: 'upper'
                )
                i++

            item.seats = Und.uniq item.seats
            item.seats.sort()
            item.textSeats = item.seats.join ', '
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push @fakeItem()
                i++
            return items

    $scope.ticket.loadData()
