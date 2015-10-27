class MatchHighlight extends Controller then constructor: (
    $ionicPlatform, $scope, $timeout, Chance, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'highlight'

    $scope.data =
        next: no
        doRefresh: ->
            $scope.highlight.doRefresh()
            return
        loadMore: ->
            $scope.highlight.loadMore()
            return

    $scope.highlight =
        items: []
        next: no
        loadData: ->
            items = @tranfromToGrid(@fakeItems())
            @items =  items
            $scope.data.next = @next = if @items.length > 0 then Chance.bool() else no
            console.log('highlight:loadData', @items.length, JSON.stringify(@items), @next)
            return
        doRefresh: ->
            $this = @
            console.log 'highlight:doRefresh'
            $timeout(->
                console.log 'highlight:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            $this = @
            console.log 'highlight:loadMore'
            $timeout(->
                console.log 'highlight:loadMore2'
                items = $this.tranfromToGrid($this.fakeItems())
                for item in items
                    $this.items.push item
                $scope.data.next = $this.next = if $this.items.length > 0 then Chance.bool() else no
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
                item = @fakeItem()
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.highlight.loadData()
