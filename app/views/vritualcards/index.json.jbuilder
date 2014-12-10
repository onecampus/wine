json.array!(@vritualcards) do |vritualcard|
  json.extract! vritualcard, :id, :user_id, :money
  json.url vritualcard_url(vritualcard, format: :json)
end
