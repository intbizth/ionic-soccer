class FanzoneQuestionary extends Controller then constructor: (
    $ionicPlatform, $scope, GoogleAnalytics
) ->
    $ionicPlatform.ready ->
        GoogleAnalytics.trackView 'questions'
