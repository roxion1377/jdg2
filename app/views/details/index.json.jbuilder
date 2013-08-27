json.array!(@details) do |detail|
  json.extract! detail, :memory, :result_id, :state_id, :time, :input
  json.url detail_url(detail, format: :json)
end
