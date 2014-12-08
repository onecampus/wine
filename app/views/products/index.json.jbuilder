json.array!(@products) do |product|
  json.extract! product, :id, :name, :price, :img, :cat_id, :description, :brand, :expiration_date, :country, :package_type, :product_model, :status, :profit, :vip_price, :is_new, :is_boutique, :unit
  json.url product_url(product, format: :json)
end
