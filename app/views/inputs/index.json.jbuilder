json.array!(@inputs) do |input|
  json.extract! input, :task_id, :dir_name, :score
  json.url input_url(input, format: :json)
end
