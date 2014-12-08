json.array!(@inventories) do |inventory|
  json.extract! inventory, :id, :user_id, :product_id, :amount
  json.url inventory_url(inventory, format: :json)
end
