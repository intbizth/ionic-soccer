class TicketMembershipMain extends Controller then constructor: (
    $ionicHistory, $scope, $timeout, LoadingOverlay
) ->
    $scope.back = ->
        # TODO request abort
        $ionicHistory.goBack -1
        $timeout(->
            LoadingOverlay.hide 'ticket-membership-ticket'
        , 200)
        return
