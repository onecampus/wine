(function () {
  $(document).on('ready page:load', function () {
    var Utils = {
      setParam: function (name, value) {
        $.localStorage.set(name, value);
      },
      getParam: function(name) {
        return $.localStorage.get(name);
      },
      getJSONProductList: function() {
        var shoppingCart = Utils.getParam("shoppingCart");
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        return JsonStr.productList;
      }
    };
    var OrderDetail = {
      username: "",
      phone: "",
      address: "",
      zipcode: "",
      totalNumber: 0,
      totalAmount: 0.00
    };
    var Cart = {
      //向购物车中添加商品
      addProduct: function(product) {
        var shoppingCart = Utils.getParam("shoppingCart"),
            JsonStr = Object;
        if(shoppingCart === null || shoppingCart === "") {
          //第一次加入商品
          JsonStr = {"productList": [{"id": product.id, "name": product.name, "num": product.num, "price": product.price}], "totalNumber": product.num, "totalAmount": (product.price * product.num)};
          Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
        } else {
          JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
          var productList = JsonStr.productList;
          var result = false;
          //查找购物车中是否有该商品
          for(var i in productList) {
            if(productList[i].id == product.id) {
              productList[i].num = parseInt(productList[i].num) + parseInt(product.num);
              result = true;
            }
          }
          if(!result) {
            //没有该商品就直接加进去
            productList.push({"id": product.id, "name": product.name, "num": product.num, "price": product.price});
          }
          //重新计算总价
          JsonStr.totalNumber = parseInt(JsonStr.totalNumber) + parseInt(product.num);
          JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) + (parseInt(product.num) * parseFloat(product.price));
          OrderDetail.totalNumber = JsonStr.totalNumber;
          OrderDetail.totalAmount = JsonStr.totalAmount;
          //保存购物车
          Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
        }
      },
      //修改给买商品数量
      updateProductNum: function(id, num) {
        var shoppingCart = Utils.getParam("shoppingCart");
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var productList = JsonStr.productList;

        for(var i in productList){
          if(productList[i].id == id) {
            JsonStr.totalNumber = parseInt(JsonStr.totalNumber) + (parseInt(num) - parseInt(productList[i].num));
            JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) + ((parseInt(num) * parseFloat(productList[i].price)) - parseInt(productList[i].num) * parseFloat(productList[i].price));
            productList[i].num = parseInt(num);

            OrderDetail.totalNumber = JsonStr.totalNumber;
            OrderDetail.totalAmount = JsonStr.totalAmount;
            Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
            return;
          }
        }
      },
      //获取购物车中的所有商品
      getProductList: function() {
        var shoppingCart = Utils.getParam("shoppingCart");
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var productList = JsonStr.productList;
        OrderDetail.totalNumber = JsonStr.totalNumber;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        return productList;
      },
      //判断购物车中是否存在商品
      existProduct: function(id) {
        var shoppingCart = Utils.getParam("shoppingCart");
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var productList = JsonStr.productList;
        var result = false;
        for(var i in productList) {
          if(productList[i].id == product.id) {
            result = true;
          }
        }
        return result;
      },
      //删除购物车中商品
      deleteProduct: function(id) {
        var shoppingCart = Utils.getParam("shoppingCart");
        var JsonStr = JSON.parse(shoppingCart.substr(1, shoppingCart.length));
        var productList = JsonStr.productList;
        var list = [];
        for(var i in productList) {
          if(productList[i].id == id) {
            JsonStr.totalNumber = parseInt(JsonStr.totalNumber) - parseInt(productList[i].num);
            JsonStr.totalAmount = parseFloat(JsonStr.totalAmount) - parseInt(productList[i].num) * parseFloat(productList[i].price);
          } else {
            list.push(productList[i]);
          }
        }
        JsonStr.productList = list;
        OrderDetail.totalNumber = JsonStr.totalNumber;
        OrderDetail.totalAmount = JsonStr.totalAmount;
        Utils.setParam("shoppingCart", "'" + JSON.stringify(JsonStr));
      }
    };

    var product = {
      'id': 1,
      'name': 'dhh',
      'num': 2,
      'price': 199.98
    };
    Cart.addProduct(product);
    var productList = Cart.getProductList(); // 取出购物车商品
    alert(productList);
    console.log(productList);
  });
}).call(this);
