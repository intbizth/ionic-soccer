class FanzoneProducts extends Controller then constructor: (
    $scope, $state
) ->

    $scope.image = './img/fanzone/products/product.png'

    $scope.header = 'Online Simple store'

    $scope.company = 'บริษัท ชาร์ค 360 องศาสตูดิโอ จำกัด'
    $scope.stadium = 'ชลบุรี สเตเดี้ยม'
    $scope.address = '107/12 ม.2 ต.เสม็ด อ.เมือง จ.ชลบุรี 20000'
    $scope.tel = '0-3846-7109'
    $scope.email = 'chonburifc.online@gmail.com'

    $scope.shadow = './img/fanzone/products/product_shadow.png'

    $scope.products = [{
        id: 1
        name: 'CHONBURI FC TEE CHONBURI - Black'
        price: 890.00
        image: './img/fanzone/products/product_1.png'
    }
    {
        id: 2
        name: 'CHONBURI FC NEW ARRIVAL JERSEY'
        price: 379.00
        image: './img/fanzone/products/product_2.png'
    }
    {
        id: 3
        name: 'CHONBURI FC VS MTUTD 2015 SCARF'
        price: 250.00
        image: './img/fanzone/products/product_3.png'
    }]
