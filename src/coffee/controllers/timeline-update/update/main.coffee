class Update extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.ticket =
        items: [],
        loadData: ->
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
                    alpha: true
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
                items.push this.fakeItem()
                i++
            return items

    $scope.news =
        items: []
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            console.log('news:loadData', this.items.length, JSON.stringify(this.items))
            return
        doRefresh: ->
            console.log 'news:doRefresh'
            $this = this
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'news:loadMore'
            $this = this
            $timeout(->
                console.log 'news:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('news:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            update = Chance.update()
            user = Chance.user()
            item =
                id: Und.random(1, 9999999)
                headline: Chance.sentence()
                image: update.image.src
                user:
                    name: user.name
                    photo: user.image.src
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.ticket.loadData()
    $scope.news.loadData()

    $scope.doRefresh = ->
        $scope.ticket.loadData()
        $scope.news.doRefresh()
        return

    $scope.loadMore = ->
        $scope.news.loadMore()
        return
