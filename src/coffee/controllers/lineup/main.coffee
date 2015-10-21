class LineupMain extends Controller then constructor: (
    $rootScope, $scope, $ionicScrollDelegate, $document, $timeout, Chance, Und
) ->
    $scope.format = []
    random = Chance.integer(min: 3, max: 4)
    i = 1
    while i <= random
        $scope.format.push 0
        i++
    $scope.format = $scope.format.join '-'
    $scope.content = Chance.paragraph(sentences: Und.random(20, 200))

    $scope.footballField =
        isLock: no
        toggleLock: ->
            @isLock = !@isLock
            $ionicScrollDelegate.scrollTop yes
            $ionicScrollDelegate.freezeAllScrolls @isLock
        element: angular.element $document[0].body.getElementsByClassName 'football-field'
        data: []
        player:
            positions: []
            color: [
                '-yellow'
                '-red'
                '-greenyellow'
                '-blue'
                '-blueviolet'
                '-saddlebrown'
                '-tan'
                '-hotpink'
                '-aqua'
                '-black'
                '-cornsilk'
            ]
            randomPosition: ->
                element = $scope.footballField.element
                player = $scope.footballField.player
                player.color = Und.shuffle player.color

                console.warn 'offsetTop', element[0].offsetTop
                console.warn 'offsetHeight', element[0].offsetHeight
                console.warn 'offsetWidth', element[0].offsetWidth

                i = 1
                ii = player.color.length
                while i <= ii
                    className = player.color[i - 1]
                    style =
                        top: Und.random(element[0].offsetTop, element[0].offsetTop + element[0].offsetHeight - 50) + 'px'
                        left: Und.random(0, element[0].offsetWidth - 50) + 'px'
                    player.positions.push
                        id: Chance.hash()
                        className: className
                        style: style
                    i++

    $scope.footballField.player.randomPosition()

    $timeout(->
        $('.player').draggable(
            scroll: no
            containment: '.football-field'
            stop: (event, ui) ->
                $('.player').each (index) ->
                    offset = $(@).offset()
                    width = $(@).width()
                    height = $(@).height()

                    $scope.footballField.data.push
                        id: $(@).data 'id'
                        x: offset.left + width / 2
                        y: (offset.top + height / 2) - $scope.footballField.element[0].offsetTop
                console.warn $scope.footballField.data
        )
    )
