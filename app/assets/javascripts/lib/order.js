(function() {
  $(document).on('ready page:load', function() {
    // create_order params:
    // ship_address_id int
    // has_invoice_id 0/1 是否提供发票 invoice: {rise, content}
    // order: {ship_method, payment_method}
    // products: [{product_id, product_count}, {product_id, product_count}]
  });
}).call(this);
