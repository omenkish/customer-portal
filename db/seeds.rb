# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


# Create admin
User.create(
    name: 'Admin User',
    email: 'admin@admin.com',
    password: 'password',
    role: 'admin'
)
puts "User created successfully"

User.create(
    name: 'Agent User',
    email: 'agent@agent.com',
    password: 'password',
    role: 'agent'
)
puts "User created successfully"

User.create(
    name: 'Customer User',
    email: 'customer@customer.com',
    password: 'password',
    role: 'customer'
)

puts "User created successfully"
