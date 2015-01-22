json.array!(@groups) do |group|
  json.extract! group, :id, :product_id, :start_time, :end_time, :limit_people_count, :limit_product_count, :description, :price, :saveup, :discount, :people
  json.url group_url(group, format: :json)
end
