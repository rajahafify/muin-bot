unless Rails.env.production?
  Dir["#{Rails.root}/app/classes/**/*.rb"].each { |file| require file }
end
