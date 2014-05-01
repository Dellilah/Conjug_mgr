json.array!(@repetitions) do |repetition|
  json.extract! repetition, :id, :last, :count, :mistake, :correct, :form_id, :user_id
  json.url repetition_url(repetition, format: :json)
end
