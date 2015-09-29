class TicketMembershipMain extends Controller then constructor: (
    $scope, $state, $ionicHistory, Chance
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.permission =
        login : ''
        loadData: ->
            login = this.fakePermission()
            this.login =  login
            console.log('permission:loadData', this.login.length, JSON.stringify(this.login))
            return

        fakePermission: ->
            login = Chance.bool()
#            login = true
            return login

    $scope.permission.loadData()
