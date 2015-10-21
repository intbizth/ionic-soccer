class LineupMain extends Controller then constructor: (
    $rootScope, $scope, $ionicScrollDelegate, Chance, Und
) ->
    $scope.footballField =
        isLock: no
        toggleLock: ->
            @isLock = !@isLock
            $ionicScrollDelegate.scrollTop yes
            $ionicScrollDelegate.freezeAllScrolls @isLock

    $scope.format = []
    random = Chance.integer(min: 3, max: 4)
    i = 1
    while i <= random
        $scope.format.push 0
        i++
    $scope.format = $scope.format.join '-'

    $scope.content = Chance.paragraph(sentences: Und.random(20, 200))

    $('.player').draggable containment: '.football-field', scroll: false