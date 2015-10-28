class Ticket extends Controller then constructor: (
    $ionicHistory, $ionicPlatform, $scope, $timeout, Chance, GoogleAnalytics, Und
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'ticket'

    $scope.share = ->
        return

    $scope.seasonTicket =
        contact: 'สอบถามรายละเอียดเพิ่มเติม ฝ่ายดูแลสิทธิประโยชน์ และการจําหน่ายตั๋ว สโมสร ชลบุรี เอฟซี 038-467-109,
                เซ็นทรัล 038-053-822, วีไอพี 038-278-007, ชาร์คเอาท์เลท 038-467-609'

    $scope.matchLabel =
        sections: []
        next: false
        loadData: ->
            sections = this.fakeSections()
            if sections.length > 0
                sections = [sections[0]]
                if sections[0].items.length > 0
                    sections[0].items = [sections[0].items[0]]
            this.sections = sections
            this.next = false
            console.log('matchLabel:loadData', this.sections.length, JSON.stringify(this.sections), this.next)
            return
        doRefresh: ->
            console.log 'matchLabel:doRefresh'
            $this = this
            $timeout(->
                console.log 'matchLabel:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        loadMore: ->
            console.log 'matchLabel:loadMore'
            $this = this
            $timeout(->
                console.log 'matchLabel:loadMore2'
                sections = $this.fakeSections()
                for section in sections
                    $this.sections.push section
                if $this.sections.length > 0
                    $this.next = Chance.pick([true, false])
                else
                    $this.next = false
                console.log('matchLabel:loadMore', $this.sections.length, JSON.stringify($this.sections), $this.next)
                $scope.$broadcast 'scroll.infiniteScrollComplete'
                return
            , 2000)
            return
        fakeSection: (datetime)->
            section =
                id: Und.random(1, 9999999)
                datetime: Chance.date(datetime)
                items: this.fakeItems(datetime)
            return section
        fakeSections: ->
            sections = []
            i = 0
            ii = Und.random(0, 10)
            month = new Date().getMonth()
            year = new Date().getFullYear()
            while i < ii
                datetime =
                    year: year
                    month: month
                section = this.fakeSection(datetime)
                sections.push section
                i++
                month++
                if month > 12
                    month = 1
                    year++
            sections = Und.sortBy(sections, 'items.datetime')
            return sections
        fakeItem: (datetime) ->
            club = Chance.club()
            clubs = [
                logo: './img/logo/match_label@2x.png'
                name: 'Chonburi FC'
                score: Und.random(0, 99)
            ,
                logo: club.image.src
                name: club.name
                score: Und.random(0, 99)
            ]
            item =
                id: Und.random(1, 9999999)
                homeClub: null
                awayClub: null
                datetime: Chance.date(datetime)
                program: 'Thai Premier League'
                stadium: 'Chonburi Stadium'
                template: Chance.pick(['before', 'after'])
            if Chance.pick([true, false])
                item.homeClub = clubs[0]
                item.awayClub = clubs[1]
            else
                item.homeClub = clubs[1]
                item.awayClub = clubs[0]
            return item
        fakeItems: (datetime) ->
            items = []
            i = 0
            ii = Und.random(0, 30)
            while i < ii
                item = this.fakeItem(datetime)
                items.push item
                i++
            items = Und.sortBy(items, 'datetime')
            return items

    $scope.matchLabel.loadData()

    $scope.ticket =
        items: []
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

    $scope.ticket.loadData()

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
        $scope.matchLabel.doRefresh()
        $scope.memberTicket.doRefresh()
        $scope.ticket.loadData()
        return

    $scope.loadMore = ->
        return
