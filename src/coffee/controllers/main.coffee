###*
# NOTE:
#   With the new view caching in Ionic, Controllers are only called
#   when they are recreated or on app start, instead of every page change.
#   To listen for when this page is active (for example, to refresh data),
#   listen for the $ionicView.enter event:
#     $scope.$on('$ionicView.enter', function(e) {
#     });
###
class Main extends Controller
    constructor: ($scope, $ionicModal, $timeout, $cordovaOauth) ->
        @scope = $scope
        @modal = $ionicModal
        @timeout = $timeout
        @oauth = $cordovaOauth

        # Define login with in root scope to access on any childs.
        @setupLogin @scope

    # @param {object} $scope App root scope.
    setupLogin: ($scope) ->
        # Form data for the login modal
        $scope.loginData = {}

        # Create the login modal that we will use later
        @modal.fromTemplateUrl(
            'templates/login.html', scope: $scope
        ).then (modal) ->
            $scope.modal = modal
            # requirement of jshint
            return

        # Triggered in the login modal to close it
        $scope.closeLogin = ->
            $scope.modal.hide()

        # Open the login modal
        $scope.login = ->
            $scope.modal.show()

        # Perform the login action when the user submits the login form
        $scope.doLogin = =>
            console.log 'Doing login', $scope.loginData

            @oauth.github(
                '2aee92f1bde492399bf4',
                'x',
                ['email'],
                redirect_uri: 'http://d3c2cde1.ngrok.io'
            ).then (result) ->
                console.info angular.toJson result
            , (error) ->
                console.log angular.toJson error

            # Simulate a login delay. Remove this and replace with your login
            # code if using a login system
            #@timeout ->
            #    $scope.closeLogin()
            #, 1000
        return
