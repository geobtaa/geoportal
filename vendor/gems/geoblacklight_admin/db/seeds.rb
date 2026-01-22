# frozen_string_literal: true

require 'csv'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Elements
CSV.foreach(File.expand_path('seeds_elements.csv', File.dirname(__FILE__)), headers: true) do |row|
  hash = row.to_hash
  # YES, I'm calling eval - It's hard to seed a serialized field via a CSV file
  hash['html_attributes'] = eval(hash['html_attributes']) if hash['html_attributes'].present?
  Element.create!(hash)
end

# FormElements
CSV.foreach(File.expand_path('seeds_form_elements.csv', File.dirname(__FILE__)), headers: true) do |row|
  FormElement.create!(row.to_hash)
end

# Reference Types
CSV.foreach(File.expand_path('seeds_reference_types.csv', File.dirname(__FILE__)), headers: true) do |row|
  ReferenceType.create!(row.to_hash)
end

# Users
User.create(email: 'admin@geoblacklight.org', password: '123456', password_confirmation: '123456', admin: true)
