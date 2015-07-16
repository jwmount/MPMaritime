# to run this script (use with john_mount/ em: john.w.mount@iCloud)
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby setup.rb   
# Refs:   https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG_F
#         https://www.quandl.com/documentation#!/api/DELETE-api--version-permissions---format-_delete_2
#
# Design Intent:  Run this script without arguments.
# 1.  Edit datasets.  Can create new datasets and or change existing ones.  No deletes.  No data loads.
# 2.  Remember updates to DB index are asynch with variable long time lines.  30 mins not unusual.
# 3.  Verify results from permalinks in log.
# Issues
# 1.  Column_names cannot be changed in attributes[]. Thus ONLY way to do this is via a destroy - create sequence.

require 'quandl/client'
require 'pry'
include Quandl::Client

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

datasets = [ {source_code: 'OTNK', code: 'VLCC_TD3_TCE', 
              name: 'VLCC - Arabian Gulf to Japan(TD3) - Spot Market Freight Rate, time charter equivalent(TCE)',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
              #description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "              
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PMT', 
              name: 'VLCC - Arabian Gulf to Japan(TD3) - Spot Market Freight Rate, dollars per ton(PMT)',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
              #description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "              
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_DBBL', 
              name: 'VLCC - Arabian Gulf to Japan(TD3) - Spot Market Freight Rate, dollars per barrel(DBBL)',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
              #description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "              
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PCF', 
              name: 'VLCC - Arabian Gulf to Japan(TD3) - Spot Market Freight Rate, percent of total cargo value(PCF)',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
              #description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "              
             },
=begin
             # VLCC TD4
             {source_code: 'OTNK', code: 'VLCC_TD4_TCE', name: 'Very Large Crude Carriers, TD4, TCE',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_PMT', name: 'Very Large Crude Carriers, TD4, PMT',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_DBBL', name: 'Very Large Crude Carriers, TD4, DBBL',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_PCF', name: 'Very Large Crude Carriers, TD4, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt."
             },

             # VLCC TD15
             {source_code: 'OTNK', code: 'VLCC_TD15_TCE', name: 'Very Large Crude Carriers, TD15, TCE',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD15."
             },

             {source_code: 'OTNK', code: 'VLCC_TD15_PMT', name: 'Very Large Crude Carriers, TD15, PMT',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD15."
             },

             {source_code: 'OTNK', code: 'VLCC_TD15_DBBL', name: 'Very Large Crude Carriers, TD15, DBBL',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD15."
             },

             {source_code: 'OTNK', code: 'VLCC_TD15_PCF', name: 'Very Large Crude Carriers, TD15, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD15."
             },

            # SUEZMAX_TD7_TCE
             {source_code: 'OTNK', code: 'SUEZMAX_TD7_TCE', name: 'SUEZMAX Crude Carriers, TD7, TCE',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD7: 80,000mt, North Sea to Continent. Sullom Voe to Wilhelmshaven - excluding WRG terminal, with laydays/cancelling 7/14 days in advance. Maximum age 20 years. The calculation includes a weather margin of 5% and bunkers based on Rotterdam 0.1 percent Sulphur MGO. 2.5% total commission."
             },
             {source_code: 'OTNK', code: 'SUEZMAX_TD7_PMT', name: 'SUEZMAX Crude Carriers, TD7, PMT',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD7: 80,000mt, North Sea to Continent. Sullom Voe to Wilhelmshaven - excluding WRG terminal, with laydays/cancelling 7/14 days in advance. Maximum age 20 years. The calculation includes a weather margin of 5% and bunkers based on Rotterdam 0.1 percent Sulphur MGO. 2.5% total commission."
             },
             {source_code: 'OTNK', code: 'SUEZMAX_TD7_DBBL', name: 'SUEZMAX Crude Carriers, TD7, DBBL',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD7: 80,000mt, North Sea to Continent. Sullom Voe to Wilhelmshaven - excluding WRG terminal, with laydays/cancelling 7/14 days in advance. Maximum age 20 years. The calculation includes a weather margin of 5% and bunkers based on Rotterdam 0.1 percent Sulphur MGO. 2.5% total commission."
             },
             {source_code: 'OTNK', code: 'SUEZMAX_TD7_PCF', name: 'SUEZMAX Crude Carriers, TD7, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD7: 80,000mt, North Sea to Continent. Sullom Voe to Wilhelmshaven - excluding WRG terminal, with laydays/cancelling 7/14 days in advance. Maximum age 20 years. The calculation includes a weather margin of 5% and bunkers based on Rotterdam 0.1 percent Sulphur MGO. 2.5% total commission."
             },


            # AFRAMAX TD20
              {source_code: 'OTNK', code: 'AFRAMAX_TD20_TCE', name: 'Aframax Crude Carriers, TD20, TCE',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD20: 130,000mt, West Africa to Continent. Off Shore Bonny to Rotterdam"
             },
              {source_code: 'OTNK', code: 'AFRAMAX_TD20_PMT', name: 'Aframax Crude Carriers, TD20, PMT',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD20: 130,000mt, West Africa to Continent. Off Shore Bonny to Rotterdam"
             },
              {source_code: 'OTNK', code: 'AFRAMAX_TD20_DBBL', name: 'Aframax Crude Carriers, TD20, DBBL',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD20: 130,000mt, West Africa to Continent. Off Shore Bonny to Rotterdam"
             },
              {source_code: 'OTNK', code: 'AFRAMAX_TD20_PCF', name: 'Aframax Crude Carriers, TD20, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD20: 130,000mt, West Africa to Continent. Off Shore Bonny to Rotterdam"
             },

            # MR TD2
              {source_code: 'OTNK', code: 'MR_TD2_TCE', name: 'MR Crude Carriers, TD2, TCE',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD2 from MEG to Singapore, VLCC vessels of 260,000mt or larger."
             },
              {source_code: 'OTNK', code: 'MR_TD2_PMT', name: 'MR Large Crude Carriers, TD2, PMT',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD2 from MEG to Singapore, VLCC vessels of 260,000mt or larger."
             },
              {source_code: 'OTNK', code: 'MR_TD2_DBBL', name: 'MR Large Crude Carriers, TD2, DBBL',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD2 from MEG to Singapore, VLCC vessels of 260,000mt or larger."
             },
              {source_code: 'OTNK', code: 'MR_TD2_PCF', name: 'MR Crude Carriers, TD2, PCF',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD2 from MEG to Singapore, VLCC vessels of 260,000mt or larger."
             }
=end

             #
             # LNG CARRIER DATABASE
             #
             # LNG Rates
             {source_code: 'LNG', code: 'CONV_R', 
              name: 'CONV_R - Conventional Liquid Natural Gas (LNG) Carrier Spot Market Freight Rate',
              column_names: ['Date', '$/day'], data: [], frequency: 'quarterly', 
              private: false,         # true do not show | false make visible
              description: "Conventional LNG carrier ... t.b.s."
             },
             # LNG Vessels
             {source_code: 'LNG', code: 'CONV_V', 
              name: 'CONV_V - Conventional Liquid Natural Gas (LNG) Carrier Vessels',
              column_names: ['Date', 'Vessels'], data: [], frequency: 'quarterly', 
              private: false,         # true do not show | false make visible
              description: "Conventional LNG carrier vessels  ... t.b.s."
             },
             {source_code: 'LNG', code: 'CONV_NO', 
              name: 'CONV_NO - Conventional Liquid Natural Gas (LNG) Carrier New Orders',
              column_names: ['Date', 'Vessels'], data: [], frequency: 'quarterly', 
              private: false,         # true do not show | false make visible
              description: "Conventional LNG vessel New Orders  ... t.b.s."
             },
             {source_code: 'LNG', code: 'CONV_OB', 
              name: 'CONV_OB - Conventional Liquid Natural Gas (LNG) Vessel Order Book',
              column_names: ['Date', 'Vessels'], data: [], frequency: 'quarterly', 
              private: false,         # true do not show | false make visible
              description: "Conventional LNG vessel Order Book  ... t.b.s."
             },
             {source_code: 'LNG', code: 'CONV_D', 
              name: 'CONV_D - Conventional Liquid Natural Gas (LNG) Vessel Deliveries',
              column_names: ['Date', 'Vessels'], data: [], frequency: 'quarterly', 
              private: false,         # true do not show | false make visible
              description: "Conventional LNG vessels delivered  ... t.b.s."
             },

             #
             # LPG CARRIER DATABASES, LPG_R and LPG_F
             #
             # LPG_R -- Liquid Propane Gas Carrier Rates
             {source_code: 'LPG_R', code: 'VLGC_FR', 
              name: 'Very Large Liquid Propane Gas Carriers (VLGC), Fully Refrigerated',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "The VLGC vessels primarily navigate the long routes from the countries in the Middle East region to Asia and from West Africa to the USA and Europe. The VLGCs primarily carry butane and propane.\n\nThe increasing demand for LPG especially in the Asia Pacific region is the primary driver bolstering the demand for very large gas carriers. Energy hungry countries such as Japan, China and India are the major centers for LPG imports. \n\nVLGC’s have cargo capacity in excess of 70,000 cbm. The cargo in the ships is carried at ambient pressure and in a fully-refrigerated condition. The vessels are fitted with a re-liquefaction plant that is capable of maintaining the temperature of the cargo.\n\nGas Carriers size classifications are subjective but generally place in the following size classes:\n•  Very Large Gas Carriers (VLGC) >70,000 cbm\n•  Large Gas Carriers (LGC)     50,000 - 70,000 cbm\n•  Medium Gas Carriers (MGC)     20,000 cbm - 40,000 cbm\n•  Small Gas Carriers       2,000 cbm - 20,000 cbm\n\nLPG is predominantly made up of propane and butane. It is also a colorless, clear fluid with no odor. It is carried either at these gases’ boiling point temperatures of -42.3º C (propane) and -0.5º C (butane), or under pressure at ambient temperature.\n\nSee also VLGC Fleet Statistics\n\n"
             },
             # description per PY 07/16/15
             {source_code: 'LPG_R', code: 'LGC_SR', 
              name: 'Large Liquid Propane Gas Carriers (LGC), Fully Refrigerated',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "Vessels sizes range from 50,000 to 70,000 cbm. The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia.
                            See also LGC Fleet Statistics.
                            www.Quandl.com/data/LPG_R/VLGC_F"
             },
             # description per PY 07/16/15
             {source_code: 'LPG_R', code: 'SMGC_SR', 
              name: 'Small Liquid Propane Gas Carriers (SMGC), Semi Refrigerated',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "SMGCs primarily operate on short distances and often carry olefins.  These vessels typically have a capacity of between 5,000 cbm and 20,000 cbm.\r\n\nSee also SMGC_SR Fleet Statistics"
             },
             # description per PY 07/16/15
             {source_code: 'LPG_R', code: 'SMGC_SR', 
              name: 'Lquid Ethanol Carrier (LEC)',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "Vessels nominally sized around 10,000 cbm. Ethane is produced on an industrial scale from natural gas, and as a by-product of petroleum refining. Global ethane production was estimated at 55 million tons in 2013, the overwhelming majority in the Middle East and US. The primary use of ethane is in the chemical industry in the production of ethylene, which in 
              turn is used to produce polyethylene, PVC, ethylene glycol and styrene.

              Historically, ethane has been transported in small liquefied ethane/ethylene carriers (LECs)
              designed and constructed to carry ethylene (boiling point -104°C) as well as ethane and other
              ‘normal’ LPG cargoes. Currently there are only 29 LECs larger than 10,000 cbm, with the largest having a capacity of 22,000 cbm."
             
             # description per PY 07/16/15
             {source_code: 'LPG_R', code: 'MGC_SR', 
              name: 'Medium Gas Carrier (MGC), Semi Refrigerated',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "Semi-pressurized and semi refrigerated ships consist of semi refrigerated plant with a high design pressure for the tanks capable of transporting up to 22,000 cbm. The tanks use in these ships are cylindrical in shape and are designed for a maximum working pressure of 8.5 kg/cm² and a minimum working temperature of -10°C. These ships are mainly used to carry propane.  See also MGC-SR Fleet Statistics."
             },
             
             # description per PY 07/16/15
             {source_code: 'LPG_R', code: 'MGC_FR', 
              name: 'Medium Gas Carrier (MGC), Fully Refrigerated',
              column_names: ['Date', '$/day'], data: [], frequency: 'weekly', 
              private: false,         # true do not show | false make visible
              description: "Vessel sizes range from 20,000 to 40,000 CBM. The MGCs primarily navigate intra-European routes and in the Gulf of Mexico, but also operate from the Arabian Gulf to Asia. See also MGC-FR Fleet Statistics."
             },

             #
             # LPG_FLEET
             #
             {source_code: 'LPG_F', code: 'VLGC_FR', 
              name: 'Very Large Liquid Propane Gas Carriers (VLGC), Fully Refrigerated',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "Vessels of 78,000 cbm or larger. The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia.  See also 'Very Large Gas Carrier--Fleet History.'"
             },
             {source_code: 'LPG_F', code: 'LGC_FR', 
              name: 'Large Liquid Propane Gas Carriers (LGC), Fully Refrigerated',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "Vessels sizes range from 50,000 to 70,000 cbm. The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia.
                            See also LGC Fleet Statistics.
                            www.Quandl.com/data/LPG_R/VLGC_F"
             },
             {source_code: 'LPG_F', code: 'MGC_FR', 
              name: 'Medium Liquid Propane Gas Carriers (MGC), Fully Refrigerated',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "Vessels of 35,000 cbm or larger. The principal routes for LGC vessels are from the Black Sea to the USA and from West Africa to the USA. Most of the LGC fleet is employed for transporting ammonia.  See also 'Very Large Gas Carrier--Fleet History.'"
             },
             {source_code: 'LPG_F', code: 'MGC_SR', 
              name: 'Medium Liquid Propane Gas Carriers (MGC), Semi Refrigerated',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "Semi-pressurized and semi refrigerated ships consist of semi refrigerated plant with a high design pressure for the tanks capable of transporting up to 22,000 cbm. The tanks use in these ships are cylindrical in shape and are designed for a maximum working pressure of 8.5 kg/cm² and a minimum working temperature of -10°C. These ships are mainly used to carry propane.  See also MGC-SR Fleet Statistics."
             },
             {source_code: 'LPG_F', code: 'SMGC_SR', 
              name: 'Small Liquid Propane Gas Carriers (SMGC), Semi Refrigerated',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "SMGCs primarily operate on short distances and often carry olefins.  These vessels typically have a capacity of between 5,000 cbm and 20,000 cbm.\r\n\nSee also SMGC_SR Fleet Statistics"
             },
             {source_code: 'LPG_F', code: 'ETHGC', 
              name: 'Liquid Ethanol Carriers (LEC)',
              column_names: ['Date', 'Deliveries', 'Deliveries(cbm)', 'Demolitions', 'Demolitions(cbm)', 'New Orders', 'New Orders(cbm)'], 
              private: false,         # true do not show | false make visible
              description: "Vessels nominally sized around 10,000 cbm. Ethane is produced on an industrial scale from natural gas, and as a by-product of petroleum refining. Global ethane production was estimated at 55 million tons in 2013, the overwhelming majority in the Middle East and US. The primary use of ethane is in the chemical industry in the production of ethylene, which in 
              turn is used to produce polyethylene, PVC, ethylene glycol and styrene.

              Historically, ethane has been transported in small liquefied ethane/ethylene carriers (LECs)
              designed and constructed to carry ethylene (boiling point -104°C) as well as ethane and other
              ‘normal’ LPG cargoes. Currently there are only 29 LECs larger than 10,000 cbm, with the largest having a capacity of 22,000 cbm."
             }
		]

    
  # CREATE OR EDIT EACH DATASET  
  datasets.each do |attributes|

      qc = "#{attributes[:source_code]}/#{attributes[:code]}"
       d = Dataset.find(qc)

    if d.nil? or d.name.nil?
       d = Dataset.create(attributes)
    else
       unless d.attributes.eql?(attributes)
         d.assign_attributes( :source_code  =>"#{attributes[ :source_code  ]}")
         d.assign_attributes( :code         =>"#{attributes[ :code         ]}")       
         d.assign_attributes( :name         =>"#{attributes[ :name         ]}")
         d.errors
         d.assign_attributes( :column_names =>"#{attributes[ :column_names ]}")
         d.errors
         d.assign_attributes( :data         =>"#{attributes[ :data         ]}")
         d.assign_attributes( :frequency    =>"#{attributes[ :frequency    ]}")
         d.assign_attributes( :private      =>"#{attributes[ :private      ]}")
         d.assign_attributes( :description  =>"#{attributes[ :description  ]}")
       end # unless
    end #if

    puts "#{d.attributes[:source_code]}/#{d.attributes[:code]}"
           puts "\t:name:        \t\t  #{d.attributes[:name]}"
           puts "\t:column_names:  \t  #{d.attributes[:column_names]}"
           puts "\t:frequency      \t  #{d.attributes[:frequency]}"
           puts "\t:private      \t\t  #{d.attributes[:private]}"
           #puts "\t:description \twas: '#{d.attributes[:description]}' \t\tis: '#{attributes[ :description ]}'"

    # PUSH IT TO QUANDL
    begin
      d.save
      puts "\tpermalink: www.quandl.com/data/#{qc}\n\n"
    rescue => e
      warn e.message
      puts "\n---update to #{d.code} failed.\n\n"
    end #begin

  end #datasets.each


