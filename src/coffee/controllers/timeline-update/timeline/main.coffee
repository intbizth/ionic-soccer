class Timeline extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.share = ->
        return

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
        $scope.timeline.doRefresh()
        return

    $scope.loadMore = ->
        $scope.timeline.loadMore()
        return
