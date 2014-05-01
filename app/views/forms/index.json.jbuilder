json.array!(@forms) do |form|
  json.extract! form, :id, :content, :temp, :person, :verb_id
  json.url form_url(form, format: :json)
end
