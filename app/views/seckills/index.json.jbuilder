json.array!(@seckills) do |seckill|
  json.extract! seckill, :id, :product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount, :people
  json.url seckill_url(seckill, format: :json)
end
