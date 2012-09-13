# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Currency.create currency: 'USD'
Currency.create currency: 'EUR'

OptionType.create option_type: 'ETO'
OptionType.create option_type: 'OTC'

QuoteName.create quote_name: 'IPE Brent'
QuoteName.create quote_name: 'IPE Gas Oil'
QuoteName.create quote_name: 'NYMEX WTI'
QuoteName.create quote_name: 'NYMEX Heat'
QuoteName.create quote_name: 'NYMEX Brent'
QuoteName.create quote_name: 'NYMEX RBOB'
QuoteName.create quote_name: 'ICE WTI'
QuoteName.create quote_name: 'ICE RBOB'
QuoteName.create quote_name: 'ICE Heat'

