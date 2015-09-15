class liveMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.headline = "Live"
    $scope.dateTop = "Sep 2015"

    $scope.matchs = [
            image1: "./img/live/chonburi.png"
            name1: "Chonburi FC"
            score: "1 -1"
            date: "1 Sep 2015"
            name2: "Suphanburi FC"
            image2: "./img/live/suphanburi.png"
    ]

    $scope.players = [
        {
            start: "19 : 00 เริ่มแข่ง"
            time1: "05 : 00"
            image1: "./img/live/yellowCard.png"
            name1: "K. Thawikan"
            time2: "29 : 23"
            image2: "./img/live/yellowCard.png"
            name2: "C. Chappuis"
            time3: "31 : 00"
            image3: "./img/live/goal.png"
            name3: "J. Mineiro"
            ht: "45 : 00 ครึ่งหลัง"
            time4: "52 : 46"
            image4: "./img/live/goal.png"
            name4: "J. Pulek"
        }
    ]
