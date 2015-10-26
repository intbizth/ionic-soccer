class LineupMain extends Controller then constructor: (
    $rootScope, $scope, $ionicScrollDelegate, $ionicPopup, $document, $timeout, Chance, Und
) ->
    $scope.format = []
    i = 1
    random = Und.random(3, 4)
    while i <= random
        $scope.format.push 0
        i++
    $scope.format = $scope.format.join '-'
    $scope.content = Chance.paragraph(sentences: Und.random(20, 200))

    $scope.footballField =
        className: 'football-field'
        getElement: ->
            angular.element $document[0].body.getElementsByClassName @className
        isLock: yes
        setLock: (value) ->
            @isLock = value
            $ionicScrollDelegate.scrollTop @isLock
            $ionicScrollDelegate.freezeAllScrolls @isLock
        player:
            width: 70
            height: 70

    $scope.personals =
        idName: 'personal'
        className: 'personal'
        items: []
        data: []
        footballField: $scope.footballField
        positionToCenterPoint: (position) ->
            return {
                x: position.left + @footballField.player.width / 2
                y: (position.top + @footballField.player.height / 2) - @footballField.getElement()[0].offsetTop
            }
        centerPointToPosition: (point) ->
            return {
                top: (point.y - (@footballField.player.height / 2)) + 'px'
                left: (point.x - (@footballField.player.width / 2)) + 'px'
            }
        isLock: yes
        setLock: (id, value) ->
            value = if value then 'disable' else 'enable'
            elementName = '#' + @idName + '-' + id
            $(elementName).draggable(value)
            return
        setLockAll: (value) ->
            @isLock = value
            value = if @isLock then 'disable' else 'enable'
            elementName = [@footballField.className, @className]
            elementName = Und.map elementName, (value) ->
                '.' + value
            elementName = elementName.join(' ')
            $(elementName).draggable(value)
            return
        checkLock: (id) ->
            elementName = '#' + @idName + '-' + id
            $(elementName).hasClass('ui-draggable-disabled')
        loadDataCenterPoints: ->
            $this = @
            $this.data = []
            elementName = [@footballField.className, @className]
            elementName = Und.map elementName, (value) ->
                '.' + value
            elementName = elementName.join(' ')
            $(elementName).each (index) ->
                centerPoint = $this.positionToCenterPoint($(@).offset())
                $this.data.push
                    id: $(@).data 'item-id'
                    x: centerPoint.x
                    y: centerPoint.y
            console.warn $this.data
        loadDrag: ->
            $this = @
            $timeout(->
                $('.personal').draggable(
                    scroll: no
                    containment: '.' + $this.footballField.className
                    start: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($this.footballField.player.width / 2)
                            y: ui.position.top + ($this.footballField.player.height / 2)
                        $(@).find('.testCenterPoint').html centerPoint.x + ',' + centerPoint.y
                    drag: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($this.footballField.player.width / 2)
                            y: ui.position.top + ($this.footballField.player.height / 2)
                        $(@).find('.testCenterPoint').html centerPoint.x + ',' + centerPoint.y
                    stop: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($this.footballField.player.width / 2)
                            y: ui.position.top + ($this.footballField.player.height / 2)
                        $(@).find('.testCenterPoint').html centerPoint.x + ',' + centerPoint.y
                )
                console.warn $this.items

                $this.footballField.setLock $this.footballField.isLock
                $this.setLockAll $this.isLock
            )
        popup: (id) ->
            $this = @
            confirmPopup = $ionicPopup.confirm
                title: 'Confirm'
                template: id
                cancelText: 'drag'
                cancelType: 'button-positive'
                okText: 'lock'
                okType: 'button-assertive'
            confirmPopup.then((res) ->
                $this.setLock id, res
            )
            return
        fakeCenterPoint: ->
            footballField = $scope.footballField.getElement()
            x =
                min: 0
                max: footballField[0].offsetWidth - $scope.footballField.player.width
            y =
                min: footballField[0].offsetTop
                max: footballField[0].offsetTop + footballField[0].offsetHeight - $scope.footballField.player.width
            x.random = Und.random(x.min, x.max)
            y.random = Und.random(y.min, y.max)
            return {
                x: x.random + ($scope.footballField.player.height / 2)
                y: y.random + ($scope.footballField.player.width / 2)
            }
        fakeItems: ->
            photos = [
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/01.pitthawas.chumnongchob.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/02.noppanon.kotchpalayuk.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/04.kroekrit.thawikan.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/05.niweat.siriwong.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/06.suttinun.phukhom.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/07.chakrit.buathong.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/08.therdsak.chaiman.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/10.popob.onmo.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/11.korrakot.wiriyaudomsiri.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/15.puritat.jarikanon.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/16.alongkon.prarhumwong.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/17.leandro.asssumpcao.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/18.sinthaweechai.hathairattanakool.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/19.adul.lahsoh.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/21.visarut.vaingan.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/24.byungkuk.cho.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/25.chonlatit.jantakam.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/26.anderson.dos-santos.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/29.watthanaphong.tabutda.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/30.chakhon.philakhlang.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/31.nurul.sriyankem.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/35.wanit.laisaen.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/36.surawich.logarwit.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/37.thiago.cunha.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/39.kirati.keawsombut.jpg'
                'http://demo.balltoro.com/media/c/size_70x70/cms/medias/personals/th/28-cho/40.warut.supphaso.jpg'
            ]
            i = 1
            ii = 11
            while i <= ii
                centerPoint = $scope.personals.fakeCenterPoint()
                position = $scope.personals.centerPointToPosition centerPoint
                @items.push
                    id: Und.random(1, 9999999)
                    photo: Chance.pick photos
                    fullname: Chance.first() + ' ' + Chance.last()
                    itemId: Chance.hash()
                    position: position
                    centerPoint: centerPoint
                i++

    footballField = $scope.footballField.getElement()

    console.warn 'footballField', 'top', footballField[0].offsetTop
    console.warn 'footballField', 'width', footballField[0].offsetWidth
    console.warn 'footballField', 'height', footballField[0].offsetHeight

    $scope.personals.fakeItems()
    $scope.personals.loadDrag()
