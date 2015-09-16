class liveMain extends Controller then constructor: (
    $scope, $ionicHistory
) ->

    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.headline = "Live"
    $scope.dateTop = "Sep 2015"

    $scope.matchLabel =
        homeClub:
            logo: "./img/live/chonburi.png"
            name: "Chonburi FC"
            score: 1
        awayClub:
            logo: "./img/live/suphanburi.png"
            name: "Suphanburi FC"
            score: 1
        dateTime: "2015-09-09T18:07:40+0700"

    $scope.players = [
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
    ]

