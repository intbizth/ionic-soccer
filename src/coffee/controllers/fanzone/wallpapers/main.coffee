class FanzoneWallpapers extends Controller then constructor: (
    $scope, $state, $timeout, Und, Chance
) ->
    $scope.data =
        next: false
        doRefresh: ->
            $scope.wallpapers.doRefresh()
            return
        loadMore: ->
            $scope.wallpapers.loadMore()
            return

    $scope.wallpapers =
        items: []
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            console.log('wallpapers:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'wallpapers:doRefresh'
            $this = this
            $timeout(->
                console.log 'wallpapers:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'wallpapers:loadMore'
            $this = this
            $timeout(->
                console.log 'wallpapers:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('wallpapers:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            wallpaper = Chance.wallpaper()
            item =
                id: Und.random(1, 9999999)
                image: wallpaper.image.src
                datetime: Chance.date()
            return item
        fakeItems: ->
            items = []
            i = 0
            ii = Und.random(0, 20)
            while i < ii
                items.push this.fakeItem()
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.wallpapers.loadData()
