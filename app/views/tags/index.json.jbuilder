json.array!(@tags) do |tag|
  json.extract! tag, :id, :name, :taggings_count
  json.url tag_url(tag, format: :json)
end
