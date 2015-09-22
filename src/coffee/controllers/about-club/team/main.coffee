class aboubClubTeam extends Controller then constructor: (
    $scope, Und, Chance
) ->
    $scope.headline = 'CHALARMCHON'
    $scope.players = [

        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
        {
            position: Chance.string(length: 1, pool: 'DFGM')
            image: 'https://placeimg.com/46/46/people?time=' + Chance.hash()
            name: Chance.name()
            number: '#' + Und.random(1, 31)
        }
    ]