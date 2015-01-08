json.array!(@seckill_orders) do |seckill_order|
  json.extract! seckill_order, :id, :order_id, :seckill_id, :seckill_count, :unit_price
  json.url seckill_order_url(seckill_order, format: :json)
end
