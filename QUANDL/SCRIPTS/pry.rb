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
cn = [ "Date", "Shared Attention", "Circle of Communication", "Elab. Ideas", "Bridges", "Ideas & Emotions"]
["BARBARA", "TONY", "JOHN", "LAUREN", "PETA"].each do |student|
	d = Dataset.create(:source_code=>"KIDSAT", :code=>"#{student}",
		:name=>"#{student} - Observation Record",
		:column_names=>[ "Date", "Shared Attention", "Circle of Communication", "Elab. Ideas", "Bridges", "Ideas & Emotions"],
		:privacy=>false, :description=>'t.b.d.'
		)
	puts d.to_s
    d.save
end

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
binding.pry

=begin
# 
# In this case, find the databsase and rename the dataset
#
d = Dataset.find('LPG/LPG_M')
puts d.name
d.name = 'Spot Contracts'
puts d.name
d.save

#d.destroy
=end