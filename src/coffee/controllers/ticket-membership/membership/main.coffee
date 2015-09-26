class Membership extends Controller then constructor: (
    $scope, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.memberZone =
        contact: 'สอบถามรายละเอียดเพิ่มเติม ฝ่ายดูแลสิทธิประโยชน์ และการจําหน่ายตั๋ว สโมสร ชลบุรี เอฟซี 038-467-109,
                เซ็นทรัล 038-053-822, วีไอพี 038-278-007, ชาร์คเอาท์เลท 038-467-609'

    $scope.memberTicket =
        items : [],
        loadData : ->
            items = this.fakeItems()
            for item in items
                if item.level == 1
                    item.class = 'gold'
                    item.level = 'Gold Member'
                else if item.level == 2
                    item.class = 'silver'
                    item.level = 'Silver Member'
                else if item.level == 3
                    item.class = 'bronze'
                    item.level = 'Bronze Member'
            this.items =  items
            console.log('memberTicket:loadData', this.items.length, JSON.stringify(this.items))
            return

        doRefresh: ->
            console.log 'memberTicket:doRefresh'
            $this = this
            $timeout(->
                console.log 'memberTicket:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return

        fakeItem : ->
            item =
                level : Chance.integer(
                    min: 1
                    max: 3
                )
                seat :
                    row : Chance.integer(
                        min: 1
                        max: 7
                    )
                    column : Chance.integer(
                        min: 1
                        max: 20
                    )
                block : Chance.character(
                    pool: 'ABCDEFGHIJKLMN'
                )
                gate : Chance.integer(
                    min: 1
                    max: 14
                )
            return item

        fakeItems : ->
            items = []
            i = 0
            ii = Und.random(0, 5)
            while i < ii
                item = this.fakeItem()
                items.push item
                i++
            return items

#    $scope.memberId =
#        items : [],
#        loadData : ->
#            items = this.fakeItems()
#            i = 1
#            for item in items
#                if i == 1
#                    item.class = 'first'
#                else if i == 2
#                    item.class = 'second'
#                else if i == 3
#                    item.class = 'third'
#                i++
#                if i > 3
#                    i = 1
#            this.items =  items
#            console.log('ticket:loadData', this.items.length, JSON.stringify(this.items))
#            return
#        fakeItem : ->
#            item =
#                id : Chance.integer(
#                    min : 1
#                    max : 9999999
#                )
#                seats : []
#                textSeats : ''
#                count : Und.random(0, 9999)
#
#            i = 0
#            ii = Und.random(1, 20)
#            while i < ii
#                item.seats.push Chance.character(
#                    alpha: true
#                    casing: 'upper'
#                )
#                i++
#            item.seats = Und.uniq item.seats
#            item.seats.sort()
#            item.textSeats = item.seats.join ', '
#            return item
#        fakeItems : ->
#            items = []
#            i = 0
#            ii = Und.random(0, 10)
#            while i < ii
#                items.push this.fakeItem()
#                i++
#            return items
#
#    $scope.news =
#        items : []
#        next : false
#        loadData : ->
#            items = this.fakeItems()
#            this.items =  items
#            console.log('news:loadData', this.items.length, JSON.stringify(this.items))
#            return
#        doRefresh : ->
#            console.log 'news:doRefresh'
#            $this = this
#            $timeout(->
#                console.log 'news:doRefresh2'
#                $this.loadData()
#                $scope.$broadcast 'scroll.refreshComplete'
#                return
#            , 2000)
#            return
#        loadMore : ->
#            console.log 'news:loadMore'
#            $this = this
#            $timeout(->
#                console.log 'news:loadMore2'
#                items = $this.fakeItems()
#                for item in items
#                    $this.items.push item
#                if $this.items.length > 0
#                    $this.next = Chance.pick([true, false])
#                else
#                    $this.next = false
#                console.log('news:loadMore', $this.items.length, JSON.stringify($this.items), $this.next)
#                $scope.$broadcast 'scroll.infiniteScrollComplete'
#                return
#            , 2000)
#            return
#        fakeItem : ->
#            item =
#                id : Chance.integer(
#                    min : 1
#                    max : 9999999
#                )
#                headline : Chance.sentence()
#                image : 'https://placeimg.com/640/292/any?time=' + Chance.hash()
#                user:
#                    name: Chance.name()
#                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
#
#            return item
#        fakeItems : ->
#            items = []
#            i = 0
#            ii = Und.random(0, 10)
#            while i < ii
#                items.push this.fakeItem()
#                i++
#            return items

    $scope.memberTicket.loadData()

    $scope.doRefresh = ->
        $scope.memberTicket.doRefresh()
        return
