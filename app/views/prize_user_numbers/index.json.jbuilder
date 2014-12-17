json.array!(@prize_user_numbers) do |prize_user_number|
  json.extract! prize_user_number, :id, :user_id, :number, :prize_act_id
  json.url prize_user_number_url(prize_user_number, format: :json)
end
