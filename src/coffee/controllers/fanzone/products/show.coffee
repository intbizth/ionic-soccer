class FanzoneProductShow extends Controller then constructor: (
    $scope, $ionicHistory
) ->
    $scope.back = ->
        $ionicHistory.goBack -1
        return

    $scope.header = 'Online Simple store'

    $scope.product = {
        id: 1
        name: 'CHONBURI FC TEE CHONBURI - Black'
        price: 890.00
        image: './img/fanzone/products/product_1.png'
        detail: 'เสื้อยืดที่สมบูรณ์แบบที่สุด ไนกี้ไม่เกรงกลัวที่จะประกาศเช่นนี้ เพราะเป็นเสื้อยืดที่สุดยอดนักกีฬาทั้งหลายเลือกสวมใส่'
        description: '- ทำจากเส้นใยคอตตอนออร์แกนิค 100%\n- คอเสื้อถูกออกแบบให้อยู่คงรูป ไม่ยับง่าย\n- เทคโนโลยีพิมพ์ลายกราฟิคที่หน้าอกแบบเรียบไปกับเนื้อผ้า'
        size: 'SIZE CHART\nรอบอก x ความยาว(นิ้ว)\n\n- S (34 x 27)\n- M (36 x 27.5)\n- L (38 x 28)\n- XL (40 x 28.5)'
        contact: 'สอบถามรายละเอียดเพิ่มเติม การสั่งซื้อ และ การจำหน่ายสินค้าของสโมสร ชลบุรี เอฟซี 038-467-109, เซ็นทรัล 038-053-822, วีไอพี 038-278-007, ชาร์คเอาท์เลท 038-467-609'
    }
