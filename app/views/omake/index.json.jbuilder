json.array!(@omakes) do |omake|
  json.extract! omake, 
  json.url omake_url(omake, format: :json)
end
