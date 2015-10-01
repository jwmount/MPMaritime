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
=end
d = Dataset.create(
                    :source_code => 'OTKR_R',
	                :code        => 'VLCC_TD3_DBBL',
                    :name        => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as $/bbl',
                    :column_names=> ["Date", "$/bbl"],
                    :from_date   => "2000-Jan-04",
                    :to_date     => "2015-Jun-04",
                    :description => 'VLCC - Arabian Gulf to Japan (TD3) - Spot Freight Rate - as %/bbl',
	                :private     => false
	                )
desc = "<h4>VLCC NETT TCE VESSEL & ROUTE DESCRIPTIONS.</h4><h5>Vessel Characteristics</h5><ul><li>Max of 300,000 metric tons (MT) deadweight (DWT)<li>double hull<li>155,000 Suez Canal net tonage (SCNT) <li>160,000 Gross register tonnage (GRT)</ul> <h5>Steaming parameters</h5> <ul> <li>13.0 knots on 70 mt laden / 12.5 knots on 53 mt ballast IFO (380CST) </ul> <h5>Time allowances</h5> <ul> <li>In port: 2 days <li>loading 20 mt per day <li>2 days discharging 110 mt per day <li>1.5 days waiting/anchor 10mt per day. </ul> <p> <h5>Baltic Routes</h5> <p>The published VLCC nett time-charter equivalent(TCE) is an average of the rates derived from Baltic Index routes TD1 and TD3. <p> <h5>Baltic Index Route TD1</h5> 280000 mt Ras Tanura/LOOP laydays canceling 20/30 days in advance max age 20 years. Via: Laden - Cape of Good Hope, Ballast - Cape of Good Hope The calculation is based on current market practice of ballasting the vessel back via the Suez Canal and Suez Canal rebate to apply. Bunkers based on Singapore 380 CST. Weather margin 5%. The calculation does not include the Fixed Rate Differential for any Emissions Control Area (ECA). 2.5% total commission. <h5>Baltic Index Route TD3</h5> 265000 mt Ras Tanura/Chiba laydays canceling 30/40 days in advance max age 15 years. The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission <h5>VLCC Nett Weight TCE Calculation Process<a href='#footnote-1'>[1]</a></h5> <p> For TD1, TCE is simply the average daily net operating cost, or Income (Y) minus Expenses(X) divided by length of voyage in days(N). In other words, TCE = (Y - X) / N. </p> <h5>Methodology</h5> <h5>Calculating Total Trip Expense for TD1</h5> <ol> <li>Compute laden and ballast days -- The laden days are derived by adding a weather factor (5%) to the laden miles (12,338) and dividing the result by the daily speed (13.0 knots per hour multiplied by 24 hours). The ballast days are calculated in the same manner, with the ballast miles (9,631) but basis a speed 12.5 knots being used. <li>Compute bunker costs -- total bunker costs are the sum of: <ul> <li>For the trip's Intermediate Fuel Oil (IFO) consumption while loading, the loading days (2 days) are multiplied by the daily IFO loading consumption (20 mt per day). <li>For the trip's IFO laden consumption, the laden days (41.52) are multiplied by the daily IFO laden consumption (70 mt per day). <li>For the trip's IFO ballast consumption, the ballast days (33.71) plus the days the vessel is transiting the canal (1 day) are multiplied by the daily IFO ballast consumption (53 mt per day). <li>For the trip's IFO consumption while discharging, the discharging days (2 days)are multiplied by the daily IFO discharging consumption (110 mt per day). <li>Finally for the trip's IFO consumption while waiting, the waiting days (1.5 days) are multiplied by the daily IFO waiting consumption (10 mt per day). <li>Adding the results from the calculations described above generates the trip's total IFO consumption. <li>This figure is then multiplied by the IFO market price per mt (based on Singapore 380 CST and supplied by Bunkerworld), which produces the total IFO cost for the trip. </ul> <li>Suez Canal Charges apply when the vessel is ballasting and are determined by adding the Suez Canal Port Costs to the Suez Canal Dues (this figure is calculated using the scaled Suez Canal Net Tonnage factors that are provided by the Suez Canal Authority. A 20% discount and a 2% double hull reduction are included). As the latter is expressed in SDR 'Special Drawing Rights' it is divided by the $/SDR rate to be converted into dollars. Foreign exchange rates (including SDRs) are sourced from XE.com. <li>Trip Total Expense is the sum of the total IFO cost, the Suez Canal dues, the load port charges (Ras Tanura) and the discharge port charges (Loop). All port cost related information is provided by Cory Brothers Shipping. </ol> <h5>Calculating Total Trip Income for TD1</h5> <ol> <li>The Gross Freight <em>(TOTAL FREIGHT INCOME????)</em> of the voyage is calculated by multiplying the cargo quantity (280,000 Mts) by the Worldscale flat rate and by the Baltic Exchange daily Worldscale route assessment for TD1, divided by 100 as market levels of freight are expressed as a percentage of the nominal freight rate. <li>Discounting the gross freight by the broker commission (2.5%) produces the Nett Freight Duration <li>The total voyage days are the sum of loading (2), laden (41.52), ballast (33.71), canal (1), discharging (2), and waiting (1.5) days. </ol> <h4>TD1 TCE</h4> THIS SECTION IS INCHOHERENT AND NEEDS RE WRITING -- REVIEW WITH THIS IN MIND <p>Nett Income(NY) equals net freight(NF) - total expenses(TX). NY = NF - TX <p>TD1 TCE equals NY divided by Duration (D). TCE = NY/D. For TD1 D is 81.73. <em>Really? every voyage? Where did this come from?</em> <h4>TD3 TCE</h4> THIS SECTION IS INCHOHERENT AND NEEDS RE WRITING -- REVIEW WITH THIS IN MIND <p>The nett Timecharter Equivalent equals income(Y) minus total expenses(X) divided by duration in days(D) -- TCE = (Y - X) / D. </p> <h5>Calculating Total Trip Expenses for TD3</h5> <ol> <li>Calculate laden and ballast days <ul> <li>The laden days are derived by adding a weather factor (5%) to the laden miles (6,654) and dividing the result by the daily speed (13.0 knots per hour multiplied by 24 hours). <li>The ballast days are calculated in the same manner, with the ballast miles (6,654) but basis a speed 12.5 knots being used. </ul> <li>Compute Intermediate Fuel Oil (IFO) costs <ul>Trip total IFO is the sum of: <li>Loading--Compute IFO consumption while loading, the loading days (2 days) are multiplied by the daily IFO loading consumption (20 mt per day). <li>Laden--Compute IFO based on count of laden days (22.39) multiplied by the daily IFO laden consumption (70 mt per day). <li>Ballast--For the trip's IFO ballast days (23.29) are multiplied by the daily IFO ballast consumption (53 mt per day). <li>Discharging--discharging days (2 days) are multiplied by the daily IFO discharging consumption (110 mt per day). <em>?????</em> <li>Waiting IFO--waiting days (1 day) are multiplied by the daily IFO waiting consumption (10 mt per day). </ul> <li>Total Trip IFO is the sum of the IFO calculations multiplied by the IFO market price per mt (based on Singapore 380 CST and supplied by Bunkerworld). <li>Trip Total Expenses are the sum of: <ul> <li>total IFO costs <li>load port charges (Ras Tanura) <li>discharge port charges (Chiba – This figure is divided by the USD/Yen rate as this port's charges are provided in Yen). <li>Foreign exchange rates (including SDRs) are sourced from XE.com. All port cost related information is provided by Cory Brothers Shipping. </ul> </ol> <h5>Total Trip Income for TD3</h5> <p>The Gross Freight of the voyage is cargo quantity (265,000 Mts) times the Worldscale flat rate times the Baltic daily Worldscale route assessment for TD3 divided by 100 (market levels of freight are expressed as a percentage of the nominal freight rate). <p>Note: Gross freight allows for the Keiyo Sea Berth Worldscale differential. <p>Discounting the gross freight by the broker commission (2.5%) produces the Nett Freight. <h5>Duration for TD3</h5> Total voyage days is the sum of loading (2 days), laden (22.39 days), ballast (23.29 days), discharging (2 days) and waiting (1 day). <h5>Calculating TD3 TCE</h5> <ol> <li>Nett Income equals Net freight minus total expenses. <li>Nett Timecharter Equivalent rate equals net income divided by total voyage days (50.68). <em>50.68 comes from where?????</em> </ol> <h4> VLCC Nett Timecharter Equivalent (VLCC TCE) is the average of the TD1 and TD3 TCE rates.</h4> <i>THIS AVERAGE NEEDS A DENOMINATOR, WHAT IS THE WEIGHTING SCHEME? ? ?</i> <ul>Sources <li>Bunker Prices used in this calculation are provided under licence by Bunkerworld. <li>Exchange Rates used in this calculation are provided under licence by XE.com. <li>All port cost related information is provided by Cory Brothers Shipping. To view the TCE port cost rates please click here. <em>WHERE ? ? ? ? ?</em> <p id='footnote-1'>[1] Nett Weight is the weight, or mass, of the goods themselves without any packaging.</p>"
=begin
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
d = Dataset.find('MPM_04/VLCC_TD3_TEST')
d.description = desc
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