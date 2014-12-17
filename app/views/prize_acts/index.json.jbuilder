json.array!(@prize_acts) do |prize_act|
  json.extract! prize_act, :id, :name, :desc, :prize_type, :start_time, :end_time, :is_open, :join_num, :person_limit
  json.url prize_act_url(prize_act, format: :json)
end
