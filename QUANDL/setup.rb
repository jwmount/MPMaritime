# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby setup.rb   use with john_mount/ em: john.w.mount@iCloud
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
# Design Intent:  Run this script without arguments.
# 1.  Edit datasets.  Can create new datasets and or change existing ones.  No deletes.  No data loads.
# 2.  Remember updates to DB index are asynch with variable long time lines.  30 mins not unusual.
# 3.  Verify results from permalinks in log.
# Database: Crude Oil - Spot Freight Rates

require 'quandl/client'
require 'pry'
include Quandl::Client

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

datasets = [ {source_code: 'OTNK', code: 'VLCC_TD3_TCE', name: 'VLCC’s - Arabian Gulf to Japan - Freight expressed as Time Charter Equivalent',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PMT', name: 'VLCC’s - Arabian Gulf to Japan - Freight expressed in $/ton carried',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_DBBL', name: 'VLCC’s - Arabian Gulf to Japan - Freight expressed in $/bbl lifted',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PCF', name: 'VLCC’s - Arabian Gulf to Japan - Freight expressed as a percent of total cargo value',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              #description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
              description: "VLCC or Very Large Crude Carriers are some of the largest cargo vessels in the world. VLCC have a size ranging between 180,000 to 320,000 DWT. They are capable of passing through the Suez Canal in Egypt, and as a result are used extensively around the North Sea, Mediterranean and West Africa. VLCC are very large shipping vessels with typical dimensions between 300 to 330 meters in length, 58 meters beam and 31 meters draft. They are known for their flexibility in using terminals and can operate in ports with some depth limitations.  These vessels are primarily used for long-haul crude transportation from the Persian Gulf to countries in Europe, Asia and North America.  These freight statistics specifically apply to route TD3 (VLCCs carrying crude oil  from the Arabian Gulf to Japan). "              
             }
=begin
             # VLCC TD4
             {source_code: 'OTNK', code: 'VLCC_TD4_TCE', name: 'Very Large Crude Carriers, TD4, TCE',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt VLCC."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_PMT', name: 'Very Large Crude Carriers, TD4, PMT',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt VLCC."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_DBBL', name: 'Very Large Crude Carriers, TD4, DBBL',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt VLCC."
             },

             {source_code: 'OTNK', code: 'VLCC_TD4_PCF', name: 'Very Large Crude Carriers, TD4, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "Route TD4, WAF to USG, vessels of 260,000mt VLCC."
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
         d.assign_attributes( :column_names =>"#{attributes[ :column_names ]}")
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

  end #setup.rb


