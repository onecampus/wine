json.array!(@withdraws) do |withdraw|
  json.extract! withdraw, :id, :user_id, :bank_card, :alipay, :we_chat_payment, :draw_type
  json.url withdraw_url(withdraw, format: :json)
end
