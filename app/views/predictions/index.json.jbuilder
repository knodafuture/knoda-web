json.array!(@predictions) do |prediction|
  json.extract! prediction, :id, :body, :expire, :resolution
  json.url prediction_url(prediction, format: :json)
end
