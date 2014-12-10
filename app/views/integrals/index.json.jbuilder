json.array!(@integrals) do |integral|
  json.extract! integral, :id, :user_id, :amount
  json.url integral_url(integral, format: :json)
end
