# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


enterprise = Enterprise.create(name: "Acme Corp.")
admin = Admin.create(first_name: "Francis", last_name: "Marineau", enterprise: enterprise, email: "frank.marineau@gmail.com", password: "password", password_confirmation: "password")