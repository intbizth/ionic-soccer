class NewsDetail extends Controller then constructor: (
    $scope, $state
) ->
    $scope.back = ->
        $state.go 'feature-main'
        return

    $scope.headline = 'News'
    $scope.name = 'Chonburi fc official'
    $scope.date = '30 November 2015'
    $scope.url = 'http://www.chonburifootballclub.com/'
    $scope.topic = 'ฟอร์มพี่หนึบมาก ซูเปอร์ตี๋ ควบ แข้งยอดเยี่ยม, ท็อปโหวต พ.ค, มิ.ย.'
    $scope.news1 = 'และในส่วนของรางวัลนักเตะยอดเยี่ยม ประจำเดือน Player of the month' +
        'จากการโหวตจากทีมงานสต๊าฟและผู้บริหารของทีมผลการโหวดตปรากฎว่า "ซูเปอร์ตี๋" สิทวีชัยหทัยรัตนกุล' +
        'ที่โชว์ฟอร์มเซฟประตูช่วยทีมเก็บแต้มสำคัญๆ เอาไว้มากมาย คว้ารางวัลดังกล่าวไปครอง'
    $scope.news2 = 'และในส่วนของรางวัลนักเตะยอดเยี่ยม ประจำเดือน Player of the month' +
        'จากการโหวตจากทีมงานสต๊าฟและผู้บริหารของทีมผลการโหวดตปรากฎว่า "ซูเปอร์ตี๋" สิทวีชัยหทัยรัตนกุล' +
        'ที่โชว์ฟอร์มเซฟประตูช่วยทีมเก็บแต้มสำคัญๆ เอาไว้มากมาย คว้ารางวัลดังกล่าวไปครอง'