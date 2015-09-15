class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.tab =
        name : 'timeline'
        selected : (tabName) ->
            console.log(tabName)
            this.name = tabName
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
                template: Chance.pick(['default', 'hightlight'])
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
        items : [],
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

    $scope.news =
        items : [],
        next : false
        loadData : ->
            items = this.fakeItems()
            this.items =  items
            console.log('news:loadData', this.items.length, JSON.stringify(this.items))
            return
        doRefresh : ->
            console.log 'news:doRefresh'
            $this = this
            $timeout(->
                console.log 'news:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore : ->
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
        fakeItem : ->
            item =
                headline : Chance.sentence()
                image : 'https://placeimg.com/640/292/any?time=' + Chance.hash()
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()

            return item
        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 10)
            while i < ii
                items.push this.fakeItem()
                i++
            return items

    $scope.news.loadData()

    $scope.update =
        doRefresh : ->
            $scope.ticket.loadData()
            $scope.news.doRefresh()
            return
        loadMore : ->
            $scope.news.loadMore()
            return
