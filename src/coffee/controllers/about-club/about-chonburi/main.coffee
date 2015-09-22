class aboutChonburiMain extends Controller then constructor: (
    $scope
) ->
    $scope.headline = 'CHALARMCHON'

    $scope.name =
        fullName:
            clubNameThai: "ชื่อสโมสร [ไทย]"
            clubNameEng: "ชื่อสโมสร [อังกฤษ]"
        nickName:
            clubNameThai: "ชื่อย่อ [ไทย]"
            clubNameEng: "ชื่อย่อ [อังกฤษ]"
        nameThai: "ชลบุรี เอฟซี"
        nameEng: "Chonburi FC"
        codeName: "ฉายา"
        league: "ลีก"

    $scope.contact =
        contactUs: "ติดต่อสโมสร"
        website: "Website"
        url: "www.chonburifootballclub.com"
        email: "Email"
        emailAddress: "info@chonburifootballclub.com"

    $scope.stadium =
        field: "สนาม"
        name: "ชลบุรีเสตเดี้ยม"
        capacity: "ความจุ (คน)"
        capacityNumber: "8,600"
        location: "ที่ตั้ง"
        address: "107/12 หมู่ 2 ตำบลเสม็ด อำเภอเมือง จังหวัดชลบุรี 20000"