class ImportsController < ApplicationController

  # todo, delete later....
  SUBWAY_ENTRANCES = 'http://data.cityofnewyork.us/api/views/drex-xx56/rows.json'
  PUBLIC_WIFI = 'http://data.cityofnewyork.us/api/views/ehc4-fktp/rows.json'
  BATHROOMS = 'http://data.cityofnewyork.us/api/views/swqh-s9ee/rows.json'
  LAUNDROMATS = 'http://data.cityofnewyork.us/api/views/uady-p6yt/rows.json'
  GREEN_MARKETS ='http://data.cityofnewyork.us/api/views/26dn-w9sw/rows.json'
  NOISE_COMPLAINTS = 'http://data.cityofnewyork.us/api/views/sw33-t3vk/rows.json'


  # this is the boss of the importers, for now.
  def boss
    require 'open-uri'

    # what's all this http://stackoverflow.com/questions/7820514/how-to-save-data-from-a-json-array-to-the-database-mongodb

    # loop through the data points for EACH URL we're sourcing.  yo.
    sources = Hash.new
    sources['subway'] = 'http://data.cityofnewyork.us/api/views/drex-xx56/rows.json'
    sources['public_wifi'] = 'http://data.cityofnewyork.us/api/views/ehc4-fktp/rows.json'
    sources['bathrooms'] = 'http://data.cityofnewyork.us/api/views/swqh-s9ee/rows.json'
    sources['laundromats'] = 'http://data.cityofnewyork.us/api/views/uady-p6yt/rows.json'
    sources['green_markets'] ='http://data.cityofnewyork.us/api/views/26dn-w9sw/rows.json'
    # sources['noise_complaints'] = 'http://data.cityofnewyork.us/api/views/sw33-t3vk/rows.json'
    
    # call import-specific array informations.

    sources.each do |key , value|
      # call corresponding function
      info = send(key)
      aurl = info["url"]
      opened = open(aurl).read
      imports = ActiveSupport::JSON.decode(opened)

      imports['data'].each do |record|
        savedata = Hash.new

        savedata["name"] = record[info['name']]
        savedata["place_type"] = info['place_type']
        savedata["human_address"] = record[info['human_address']]
        savedata["description"] = record[info['description']]

        # if it's nested... god is there a ruby-easy way to do this shit?
        if info['location'] != nil 
          savedata["lat"] = record[info['location']][info['lat']]
          savedata["lon"] = record[info['location']][info['lon']]
          
	        # ha! it's got to be longitude first.  silly.
          savedata['location'] = [ savedata['lon'].to_f, savedata['lat'].to_f ]
        else
          savedata["lat"] = record[info['lat']]
          savedata["lat"] = record[info['lon']]
        end

        @place = Places.new(savedata)
        @place.save

      end # end import inner loop

    end #end source outer loop.

  end # end function

  
  def subway
    info = Hash.new
    info['url'] = SUBWAY_ENTRANCES 
    info['location'] = 9
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "subway"
    info['name'] = 10
    info['human_address'] = 10
    info['description'] = 12

    return info
  end

  def public_wifi
    # [21, "21", nil, nil, nil, 0, nil, nil, "21", [nil, "40.844490535000034", "-73.84660241899991", nil, false, {"point"=>[-73.84660241899991, 40.844490535000034]}], "McDonald's", "245", "1515 Williamsbridge Rd", "Bronx", "10461", " ", "Fee-based", "http://www.mcdonalds.com/wireless.html"]
    info = Hash.new
    info['url'] = PUBLIC_WIFI
    info['location'] = 9
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "wifi"
    info['name'] = 10
    info['human_address'] = 12
    info['description'] = 17

    return info
  end

  def bathrooms
    #   # [443, "443", nil, nil, nil, 0, nil, nil, "443", [nil, "40.59544637400006", "-74.08151142499992", nil, false, {"rings"=>[[[-74.08151142499992, 40.59544637400006], [-74.08154427499994, 40.595498467000084], [-74.0814772999999, 40.595523007000054], [-74.08144444999994, 40.59547090800004], [-74.08151142499992, 40.59544637400006]]]}], 
    #  "1295", "R063-BLG1304", "Ps 46 S Beach Hses Playground-Building", "NYCPARKS", "BUILDING", "X", "S", "R063", " ", -2209132800, "R063", "R063", "OLD TOWN SCHOOL", " ", " ", " ", "BATHROOM", "83.3901550649164846618077717721462249755859375", "434.5754083588941512061865068972110748291015625"]
    info = Hash.new
    info['url'] = BATHROOMS
    info['location'] = 9
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "bathroom"
    info['name'] = 13
    info['human_address'] = 12
    info['description'] = 13

    return info
  end

  def green_markets
    info = Hash.new
    info['url'] = GREEN_MARKETS
    info['location'] = 9
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "bathroom"
    info['name'] = 10
    info['human_address'] = 13
    info['description'] = 13

    return queryable.near(location: [ 23.1, 12.1 ])info
  end

  def laundromats
    info = Hash.new
    info['url'] = LAUNDROMATS
    info['location'] = 17
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "laundromat"
    info['name'] = 13
    info['human_address'] = 12
    info['description'] = 13

    return info
  end

  # these will need to come in through a resque job.  This is a f'ing HUGE feed
  def noise_complaints
    info = Hash.new
    info['url'] = NOISE_COMPLAINTS
    info['location'] = 57
    info['lat'] = 1
    info['lon'] = 2
    info['place_type'] = "noise"
    info['name'] = 13
    info['human_address'] = 12
    info['description'] = 13

    return info
  end



end
