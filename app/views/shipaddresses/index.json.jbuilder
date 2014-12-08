json.array!(@shipaddresses) do |shipaddress|
  json.extract! shipaddress, :id, :user_id, :receive_name, :province, :city, :region, :address, :postcode, :tel, :mobile
  json.url shipaddress_url(shipaddress, format: :json)
end
