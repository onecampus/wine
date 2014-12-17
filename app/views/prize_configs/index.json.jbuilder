json.array!(@prize_configs) do |prize_config|
  json.extract! prize_config, :id, :prize_act_id, :prize_name, :min, :max, :prize_content, :prize_inventory, :chance
  json.url prize_config_url(prize_config, format: :json)
end
