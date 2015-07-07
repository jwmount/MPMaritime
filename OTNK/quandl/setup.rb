# to run this script, 
#    $ QUANDL_TOKEN=Z_FgEe3SYywKzHT7myYr ruby editDB.rb
# Usage:  https://github.com/quandl/quandl_client.git
#         https://www.quandl.com/data/LPG
# 
require 'quandl/client'
require 'pry'
include Quandl::Client

Quandl::Client.use 'https://www.quandl.com/api/'
Quandl::Client.token = ENV['QUANDL_TOKEN']

datasets = [ {source_code: 'OTNK', code: 'VLCC_TD3_TCE', name: 'Very Large Crude Carriers, TD3, TCE',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission"
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PMT', name: 'Very Large Crude Carriers, TD3, PMT',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission"
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_DBBL', name: 'Very Large Crude Carriers, TD3, DBBL',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission"
             },

             {source_code: 'OTNK', code: 'VLCC_TD3_PCF', name: 'Very Large Crude Carriers, TD3, PCF',
   	          column_names: ['Date', '$/day'], data: [], frequency: 'weekly', private: false,         # true do not show | false make visible
              description: "TD3: 265000 mt Ras Tanura/Chiba laydays canceling 15/30 days in advance max age 15 years.  The calculation includes a weather margin of 5% and bunkers based on Singapore 380 CST. 2.5% total commission."
             },

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
		]


  # CREATE OR EDIT EACH DATASET  
  datasets.each do |attributes|

      qc = "#{attributes[:source_code]}/#{attributes[:code]}"
       d = Dataset.find(qc)
    if d.nil? or d.name.nil?
       d = Dataset.create(attributes)
    else
       #unless d.attributes.eql?(attributes)
         d.assign_attributes( :source_code  =>"#{attributes[ :source_code  ]}")
         d.assign_attributes( :code         =>"#{attributes[ :code         ]}")       
         d.assign_attributes( :name         =>"#{attributes[ :name         ]}")
         d.assign_attributes( :column_names =>"#{attributes[ :column_names ]}")
         d.assign_attributes( :data         =>"#{attributes[ :data         ]}")
         d.assign_attributes( :frequency    =>"#{attributes[ :frequency    ]}")
         d.assign_attributes( :private      =>"#{attributes[ :private      ]}")
         d.assign_attributes( :description  =>"#{attributes[ :description  ]}")
       #end # unless
    end #if

    # PUSH IT TO QUANDL
    begin
      d.save
      puts "\nDataset with Quandl code #{d.source_code}/#{d.code} created.\n\n"
    rescue => e
      warn e.message
      puts "\n---update to #{d.code} failed.\n\n"
    end #begin

  end #setup.rb


