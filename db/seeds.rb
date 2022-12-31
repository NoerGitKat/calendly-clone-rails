# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.destroy_all
Meeting.destroy_all

user = User.create!(
  booking_link: "noerp",
  email: "noer@noer.com",
  name: "Noer Paan",
  password: "noernoer",
  password_confirmation: "noernoer"
)

meeting1 = Meeting.create!(
  color: "#38bdf8",
  description: "Nice meeting",
  duration: 15,
  location: "Zoom",
  name: "Nice 15min meeting",
  payment_required: false,
  price: nil,
  user: user
)

meeting2 = Meeting.create!(
  color: "#fbbf24",
  description: "Cool meeting",
  duration: 30,
  location: "Zoom",
  name: "Cool 30min meeting",
  payment_required: false,
  price: nil,
  user: user
)

meeting3 = Meeting.create!(
  color: "#34d399",
  description: "Ok meeting",
  duration: 60,
  location: "Zoom",
  name: "Ok 60min meeting",
  payment_required: true,
  price: 125,
  user: user
)