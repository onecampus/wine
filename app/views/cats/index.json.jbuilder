json.array!(@cats) do |cat|
  json.extract! cat, :id, :title, :content, :secret_field, :name, :parent_id, :lft, :rgt, :depth
  json.url cat_url(cat, format: :json)
end
