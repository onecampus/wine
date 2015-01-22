json.array!(@commissions) do |commission|
  json.extract! commission, :id, :user_id, :order_id, :commission_money, :percent
  json.url commission_url(commission, format: :json)
end
