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

    $scope.memberTicket.loadData()

    $scope.doRefresh = ->
        $scope.memberTicket.doRefresh()
        return
