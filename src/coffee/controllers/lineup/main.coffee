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

                console.log element

                i = 1
                ii = player.color.length
                while i <= ii
                    className = player.color[i - 1]
                    style =
                        top: Und.random(element[0].offsetTop, element[0].offsetTop + element[0].offsetHeight - 50) + 'px'
                        left: Und.random(0, element[0].offsetWidth - 50) + 'px'
                    player.positions.push
                        className: className
                        style: style
                    i++
                    console.warn 'className', className
                    console.warn 'style', JSON.stringify style

    $scope.footballField.player.randomPosition()

    $timeout(->
        $('.player').draggable containment: '.football-field', scroll: false
    )
