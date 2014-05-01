json.array!(@verbs) do |verb|
  json.extract! verb, :id, :infinitive, :translation, :group
  json.url verb_url(verb, format: :json)
end
