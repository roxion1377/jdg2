json.array!(@results) do |result|
  json.extract! result, :lang_id, :message, :state_id, :user_id, :task_id, :contest_id, :score
  json.url result_url(result, format: :json)
end
