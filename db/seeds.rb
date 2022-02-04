# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).

User.create(name: 'Jin Xiong', email: 'hsunny3993@gmail.com', password: 'solomon', password_confirmation: 'solomon')
User.create(name: 'Katherine Illingworth', email: 'katherine.illingworth@mondu.ai', password: 'solomon', password_confirmation: 'solomon')

# customer1 = Customer.create(name: 'Jin Xiong', email: 'hsunny3993@gmail.com', phone: '8613840080213')
# Account.create(customer_id: customer1.id, account_name: 'HSBC', account_number: '110000000123', account_balance: 5000)
#
# customer2 = Customer.create(name: 'Katherine Illingworth', email: 'katherine.illingworth@mondu.ai', phone: '123123123123')
# Account.create(customer_id: customer2.id, account_name: 'ICICI', account_number: '110000000124', account_balance: 5000)
