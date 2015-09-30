class MatchHighlight extends Controller then constructor: (
    $scope, $timeout, Und, Chance
) ->
    $scope.data =
        next: false
        doRefresh: ->
            $scope.highlight.doRefresh()
            return
        loadMore: ->
            $scope.highlight.loadMore()
            return

    $scope.highlight =
        items: [],
        next: false
        loadData: ->
            items = this.tranfromToGrid(this.fakeItems())
            this.items =  items
            if this.item.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            $scope.data.next = this.next
            console.log('highlight:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'highlight:doRefresh'
            $this = this
            $timeout(->
                console.log 'highlight:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'highlight:loadMore'
            $this = this
            $timeout(->
                console.log 'highlight:loadMore2'
                items = $this.tranfromToGrid($this.fakeItems())
                for item in items
                    $this.items.push item
                if $this.item.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                $scope.data.next = $this.next
                console.log('highlight:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        tranfromToGrid: (items) ->
            col = 2
            newItems = []
            i = 0
            for item in items
                if i % col == 0
                    newItem = []
                newItem.push item
                if i != 0 and i % col == 0
                    newItems.push newItem
                i++
            return newItems
        fakeItem: ->
            highlight = Chance.matchHighlight()
            item =
                id: Und.random(1, 9999999)
                image: highlight.image.src
                datetime: Chance.date()

            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 50)
            if ii % 2 != 0
                ii++
            while i < ii
                item = this.fakeItem()
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.highlight.loadData()
