class timelineAndUpdateMain extends Controller then constructor: (
    $scope, $state, Und, Chance
) ->
    $scope.back = ->
        $state.go 'feature-main'
        return

    $scope.isLive = Chance.pick([true, false])
    $scope.timelines = []

    $scope.loadTimeline = ->
        $scope.timelines = []
        i = 0
        ii = Und.random(0, 10)
        while i < ii
            timeline =
                template: Chance.pick(['default', 'hightlight'])
                datetime: Chance.date()
                images : []
                description: Chance.paragraph(
                    sentences: Und.random(1, 20)
                )
                user:
                    name: Chance.name()
                    photo: 'https://placeimg.com/46/46/people?time=' + Chance.timestamp()

            j = 0
            jj = Und.random(0, 4)
            while j < jj
                timeline.images.push 'https://placeimg.com/640/640/any?time=' + Chance.timestamp()
                j++

            $scope.timelines.push timeline
            i++

    $scope.loadTimeline()
