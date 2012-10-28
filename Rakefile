#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

MurderLevelOrange::Application.load_tasks

namespace 'import' do
	
	desc "Import place data from NYC Open Data site"
	task :boss do
		# requirez
		require 'open-uri'

		# the URLs
	  SUBWAY_ENTRANCES = 'http://data.cityofnewyork.us/api/views/drex-xx56/rows.json'
	  PUBLIC_WIFI = 'http://data.cityofnewyork.us/api/views/ehc4-fktp/rows.json'
	  BATHROOMS = 'http://data.cityofnewyork.us/api/views/swqh-s9ee/rows.json'
	  LAUNDROMATS = 'http://data.cityofnewyork.us/api/views/uady-p6yt/rows.json'
	  GREEN_MARKETS ='http://data.cityofnewyork.us/api/views/26dn-w9sw/rows.json'
	  NOISE_COMPLAINTS = 'http://data.cityofnewyork.us/api/views/sw33-t3vk/rows.json'

	  # one loop to rule them all
	  aurl = NOISE_COMPLAINTS
    opened = open(aurl).read
    imports = ActiveSupport::JSON.decode(opened)
    # what's all this http://stackoverflow.com/questions/7820514/how-to-save-data-from-a-json-array-to-the-database-mongodb
    outer = 0
    imports['data'].each do |record|
      i = 0
      outer = outer + 1
      record.each do |item|
        i = i + 1
        p i
        p item 
        p '-------------'
        if i > 5
          break
        end
      end
      p record

      # p record[10]
      # p record[13]
      # p record[15]
      # p record[17][1]
      # p record[17][2]

      p '------------------------------'
    end

    if outer > 3
      break
    end


  # import tasks for each of the f'ing customized URLs
  namespace 'nyc_data' do

  	desc "Import some subway shit"
  	task :subway do
  		vartest = Rake::Task[:testing].invoke
  		p vartest

  		
  	# 	opened = open(SUBWAY_ENTRANCES).read
			# imports = ActiveSupport::JSON.decode(opened)

			# #[1895, "1895", nil, nil, nil, 0, nil, nil, "1895", 
			# #[nil, "40.73998433400004", "-73.98634300099991", nil, false, {"point"=>[-73.98634300099991, 40.73998433400004]}], 
			# #{}"Park Ave & 23rd St At Se Corner (Uptown Only)", "http://www.mta.info/nyct/service/", "4-6-6 Express"]
   #    p record[10] # address
   #    p record[12] # description


   #    # lat and long for subways
   #    p record[9][1]
   #    p record[9][2]



  	end


  end



	end



end
