class LineupMain extends Controller then constructor: (
    $rootScope, $scope, $ionicScrollDelegate, $document, $timeout, Chance, Und
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
            $ionicScrollDelegate.scrollTop value
            $ionicScrollDelegate.freezeAllScrolls value
            @isLock = value
        player:
            width: 70
            height: 70

    $scope.personals =
        items: []
        data: []
        getCenterPoint: (element) ->
            footballField = $scope.footballField.getElement()
            return {
                x: element.offset().left + element.width() / 2
                y: (element.offset().top + element.height() / 2) - footballField[0].offsetTop
            }
        centerPointToPosition: (point) ->
            return {
                top: (point.y - ($scope.footballField.player.height / 2)) + 'px'
                left: (point.x - ($scope.footballField.player.width / 2)) + 'px'
            }
        loadDrag: ->
            $timeout(->
                $scope.footballField.setLock($scope.footballField.isLock)
                $('.player').draggable(
                    scroll: no
                    containment: '.' + $scope.footballField.className
                    start: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($scope.footballField.player.width / 2)
                            y: ui.position.top + ($scope.footballField.player.height / 2)
                        $(@).find('.centerPoint').html centerPoint.x + ',' + centerPoint.y
                    drag: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($scope.footballField.player.width / 2)
                            y: ui.position.top + ($scope.footballField.player.height / 2)
                        $(@).find('.centerPoint').html centerPoint.x + ',' + centerPoint.y
                    stop: (event, ui) ->
                        centerPoint =
                            x: ui.position.left + ($scope.footballField.player.width / 2)
                            y: ui.position.top + ($scope.footballField.player.height / 2)
                        $(@).find('.centerPoint').html centerPoint.x + ',' + centerPoint.y
                        $('.player').each (index) ->
                            centerPoint = $scope.personals.getCenterPoint($(@))
                            $scope.personals.data.push
                                 id: $(@).data 'id'
                                 x: centerPoint.x
                                 y: centerPoint.y
                        console.warn $scope.personals.data
                )
                console.warn $scope.personals.items
            )
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
            i = 1
            ii = 11
            while i <= ii
                centerPoint = $scope.personals.fakeCenterPoint()
                position = $scope.personals.centerPointToPosition centerPoint
                @items.push
                    id: Chance.hash()
                    top: position.top
                    left: position.left
                    centerPoint: centerPoint
                i++

    footballField = $scope.footballField.getElement()

    console.warn 'footballField', 'top', footballField[0].offsetTop
    console.warn 'footballField', 'width', footballField[0].offsetWidth
    console.warn 'footballField', 'height', footballField[0].offsetHeight

    $scope.personals.fakeItems()
    $scope.personals.loadDrag()
