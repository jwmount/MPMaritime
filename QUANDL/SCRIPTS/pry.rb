# Quandl test bed
# Note, can use command line pyy command using lines 7-13
# 
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/<dbname>
#         QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby pry.rb
# 
# Find by Database name, as in www.quandle.com/data/LPG_R
# db = Quandl::Client::Source.find('LPG_F')

require 'quandl/client'
require 'pry'

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

include Quandl::Client


=begin

desc = "**Capesize**

The term Capesize applies to the largest vessel class in the dry cargo trade. These 
ships are typically 180,000 dwt (dead weight tons) and higher and typically haul iron 
ore and coal. By definition they are any dry bulk carrier that is too large to transit 
the Panama Canal, which implies any carrier greater than 100,000 dwt. 

**Panamax**

The term Panamax applies to the vessel class that ranges from 65,000 to 85,000 dwt and 
the largest class of vessel that can transit the Panama Canal.  They typically haul 
ore, coal, grains and some minor bulk cargo.

**Supramax** 

The term Supramax applies to vessel class ranges from 40,000 to 65,000 dwt. This asset 
class is mostly regional in nature and trades in mainly agricultural products and 
minor bulks, though they do trade in major bulks where port restrictions  require 
smaller ships.  A Supramax vessel is typically 150 – 200 meters in length and 
they have five cargo holds and four cranes.

**Handysize**

The term Handysize applies to the smallest vessel class and range from 10,000 to 
35,000 DWT. These smaller Handysize and Handymax vessels are the workhorses of the dry 
bulk market, and they have the highest rate of growth."


#db = Quandl::Client::Source.find('MPM_01')
#db.code = 'BNKR_F'
#db.save


#vlgc   = Dataset.find('OTKR/VLGC_FR')
#d.description = desc
#cols = ['Date', '$/day']
=end

# This stanza resets each of the four Datasets of OTKR_R
=begin
d = Dataset.find("OTKR_R/VLCC_TD3_PMT")
d.assign_attributes(:source_code => 'OTKR_R',
	                :code        => 'VLCC_TD3_PMT',
                    :name        => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as $/mt (PMT)',
                    :column_names=> ["Date", "%/mt"],
                    :from_date   => "2000-Jan-04",
                    :to_date     => "2015-Jun-04",
                    :description => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as $/mt (PMT)',
	                :private     => false
	                )
	                
d = Dataset.find("OTKR_R/VLCC_TD3_PCF")
d.assign_attributes(:source_code => 'OTKR_R',
	                :code        => 'VLCC_TD3_PCF',
                    :name        => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as % of cargo value (PCF)',
                    :column_names=> ["Date", "% Cargo Value"],
                    :from_date   => "2000-Jan-04",
                    :to_date     => "2015-Jun-04",
                    :description => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as % of cargo value (PCF)',
	                :private     => false
	                )

d = Dataset.find("OTKR_R/VLCC_TD3_DBBL")
d.assign_attributes(:source_code => 'OTKR_R',
	                :code        => 'VLCC_TD3_DBBL',
                    :name        => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as $/bbl',
                    :column_names=> ["Date", "$/bbl"],
                    :from_date   => "2000-Jan-04",
                    :to_date     => "2015-Jun-04",
                    :description => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as %/bbl',
	                :private     => false
	                )
d = Dataset.find("OTKR_R/VLCC_TD3_TCE")
d.assign_attributes(:source_code => 'OTKR_R',
	                :code        => 'VLCC_TD3_TCE',
                    :name        => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate (TCE)',
                    :column_names=> ["Date", "$/day"],
                    :from_date   => "2000-Jan-04",
                    :to_date     => "2015-Jun-04",
                    :description => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate (TCE)',
	                :private     => false
	                )
=end
binding.pry
d.save
if d.errors.any?
	puts d.errors
    puts d.error_messages
else
	puts "No errors."
end

=begin
# 
# Find the databsase and rename it
#
d = Dataset.find('LPG/LPG_M')
puts d.name
d.name = 'Spot Contracts'
puts d.name
d.save

#d.destroy
=end