class Update extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.data =
        next: no
        doRefresh: ->
            $scope.ticket.loadData()
            $scope.news.doRefresh()
            return
        loadMore: ->
            $scope.news.loadMore()
            return

    $scope.ticket =
        items: [],
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
            ii = Und.random(0, 2)
            while i < ii
                items.push @fakeItem()
                i++
            return items

    $scope.news =
        items: []
        next: no
        loadData: ->
            items = @fakeItems()
            $scope.data.next = @next = if @items.length > 0 then Chance.bool() else no
            console.log('news:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            console.log 'news:doRefresh'
            $this = @
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'news:loadMore'
            $this = @
            $timeout(->
                console.log 'news:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                $scope.data.next = $this.next = if $this.items.length > 0 then Chance.bool() else no
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
                items.push @fakeItem()
                i++
            return items

    $scope.ticket.loadData()
    $scope.news.loadData()
