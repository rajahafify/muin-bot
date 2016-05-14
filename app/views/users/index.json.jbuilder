json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :facebook_uuid, :profile_pic, :locale, :gender
  json.url user_url(user, format: :json)
end
