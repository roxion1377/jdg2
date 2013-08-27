json.array!(@tasks) do |task|
  json.extract! task, :name, :tl, :ml, :body, :judge_type, :contest_id
  json.url task_url(task, format: :json)
end
