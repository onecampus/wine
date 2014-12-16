json.array!(@product_orders) do |product_order|
  json.extract! product_order, :id, :order_id, :product_id, :product_count, :unit_price
  json.url product_order_url(product_order, format: :json)
end
