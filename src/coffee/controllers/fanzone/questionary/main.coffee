class FanzoneQuestionary extends Controller then constructor: (
    $cordovaGoogleAnalytics, $ionicPlatform, $scope
) ->
    $ionicPlatform.ready ->
        $cordovaGoogleAnalytics.trackView 'questions'
