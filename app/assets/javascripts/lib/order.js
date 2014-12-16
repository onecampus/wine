(function() {
  $(document).on('ready page:load', function() {
    // create_order params:
    // ship_address_id int
    // has_invoice_id 0/1 是否提供发票 invoice: {rise, content}
    // ship_method, payment_method
    // products: [{product_id, product_count}, {product_id, product_count}]
    $.ajax({
      type: "POST",
      url: "/customer/orders/create",
      data: {
        ship_address_id: 1,
        has_invoice_id: 1, // if has_invoice_id == 0; no invoice
        invoice: {
          rise: "a",
          content: "b"
        },
        ship_method: 'a',
        payment_method: 'b',
        products: [
          {
            product_id: 1,
            product_count: 5
          },
          {
            product_id: 2,
            product_count: 8
          }
        ]
      },
      dataType: "json",
      success: function(data) {
        // code
        alert(data);
      },
      complete: function(XMLHttpRequest, textStatus){
        // code
      },
      error: function(){
        // code
      }
    });
  });
}).call(this);
