class ProductDetail extends Controller then constructor: (
    $scope, $state, $ionicHistory, $timeout, Und, Chance
) ->
    $scope.back = ->
        $state.go 'feature'
        return

    $scope.product =
        item : {},
        loadData : ->
            item = this.fakeItem()
            this.item =  item
            console.log('product:loadData', JSON.stringify(this.item))
            return
        doRefresh : ->
            console.log 'product:doRefresh'
            $this = this
            $timeout(->
                console.log 'product:doRefresh2'
                $this.loadData()
                $scope.$broadcast 'scroll.refreshComplete'
                return
            , 2000)
            return
        fakeItem : ->
            product = Chance.product()
            item =
                id: Und.random(1, 9999999)
                title: 'Online Simple store'
#                image: '../img/fanzone/products/product_' + Und.random(1, 3) + '@2x.png'
                image: product.image.css
                name: Chance.sentence()
                detail: Chance.paragraph()
                price: Chance.floating({min: 0, max: 9999999, fixed: 2})
                contact: Chance.sentence()
                datetime: Chance.date()
            return item

    $scope.product.loadData()
