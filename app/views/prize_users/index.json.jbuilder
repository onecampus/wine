json.array!(@prize_users) do |prize_user|
  json.extract! prize_user, :id, :user_id, :prize_config_id
  json.url prize_user_url(prize_user, format: :json)
end
