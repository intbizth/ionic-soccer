class FanzoneProducts extends Controller then constructor: (
    $scope, $state, $timeout, Und, Chance
) ->
    $scope.data =
        next: false
        doRefresh: ->
            $scope.products.doRefresh()
            return
        loadMore: ->
            $scope.products.loadMore()
            return

    $scope.title = 'Online Simple store'

    $scope.company = 'บริษัท ชาร์ค 360 องศาสตูดิโอ จำกัด'
    $scope.stadium = 'ชลบุรี สเตเดี้ยม'
    $scope.address = '107/12 ม.2 ต.เสม็ด อ.เมือง จ.ชลบุรี 20000'
    $scope.tel = '0-3846-7109'
    $scope.email = 'chonburifc.online@gmail.com'

    $scope.products =
        items: []
        next: false
        loadData: ->
            items = this.fakeItems()
            this.items =  items
            if this.items.length > 0
                this.next = Chance.pick([true, false])
            else
                this.next = false
            $scope.data.next = this.next
            console.log('products:loadData', this.items.length, JSON.stringify(this.items), this.next)
            return
        doRefresh: ->
            console.log 'products:doRefresh'
            $this = this
            $timeout(->
                console.log 'products:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'products:loadMore'
            $this = this
            $timeout(->
                console.log 'products:loadMore2'
                items = $this.fakeItems()
                for item in items
                    $this.items.push item
                if $this.items.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                $scope.data.next = $this.next
                console.log('products:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeItem: ->
            product = Chance.product()
            item =
                id: Und.random(1, 9999999)
                name: Chance.sentence()
                price: Chance.floating({min: 0, max: 9999999, fixed: 2})
                image: product.image.src
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

    $scope.products.loadData()
