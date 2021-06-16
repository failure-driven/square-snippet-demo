# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

TOGGLES = %i[
  protal
  user_nav
].freeze

TOGGLES.each do |toggle|
  Flipper[toggle].add
end

(Flipper.features.map(&:key).map(&:to_sym) - TOGGLES).each do |old_toggle|
  Flipper[old_toggle].remove
end