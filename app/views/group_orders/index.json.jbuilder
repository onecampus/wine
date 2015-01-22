json.array!(@group_orders) do |group_order|
  json.extract! group_order, :id, :order_id, :group_id, :group_count, :unit_price
  json.url group_order_url(group_order, format: :json)
end
