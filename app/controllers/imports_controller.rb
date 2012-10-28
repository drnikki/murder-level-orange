class ImportsController < ApplicationController


  SUBWAY_ENTRANCES = 'http://data.cityofnewyork.us/api/views/drex-xx56/rows.json'
  PUBLIC_WIFI = 'http://data.cityofnewyork.us/api/views/ehc4-fktp/rows.json'
  BATHROOMS = 'http://data.cityofnewyork.us/api/views/swqh-s9ee/rows.json'
  LAUNDROMATS = 'http://data.cityofnewyork.us/api/views/uady-p6yt/rows.json'
  GREEN_MARKETS ='http://data.cityofnewyork.us/api/views/26dn-w9sw/rows.json'
  NOISE_COMPLAINTS = 'http://data.cityofnewyork.us/api/views/sw33-t3vk/rows.json'


  # this is the boss of the importers, for now.
  def boss
    require 'open-uri'

    aurl = SUBWAY_ENTRANCES
    opened = open(aurl).read
    imports = ActiveSupport::JSON.decode(opened)
    # what's all this http://stackoverflow.com/questions/7820514/how-to-save-data-from-a-json-array-to-the-database-mongodb
    outer = 0
    # call import-specific array informations.
    info = subway

    # loop through them
    imports['data'].each do |record|
      savedata = Hash.new

      savedata["name"] = record[info['name']]
      savedata["place_type"] = info['place_type']
      savedata["human_address"] = record[info['human_address']]
      savedata["description"] = record[info['description']]
      # if it's nested... god is there a ruby-easy way to do this shit?
      if info['location'] != nil 
        #savedata['location'][] = record[info['location']][info['lat']]
        #savedata['location'][] = record[info['location']][info['lon']]

        savedata["lat"] = record[info['location']][info['lat']]
        savedata["lon"] = record[info['location']][info['lon']]
        savedata['location'] = Array.new( savedata['lat'].to_integer, savedata['lon'].to_integer )
      else
        savedata["lat"] = record[info['lat']]
        savedata["lat"] = record[info['lon']]
      end

      @place = Places.new(savedata)
      @place.save

    end










    #   i = 0
    #   outer = outer + 1
    #   record.each do |item|
    #     i = i + 1
    #     p i
    #     p item 
    #     p '-------------'
    #     if i > 5
    #       break
    #     end
    #   end
    #   p record

    #   # p record[10]
    #   # p record[13]
    #   # p record[15]
    #   # p record[17][1]
    #   # p record[17][2]

    #   p '------------------------------'
    # end

    # if outer > 3
    #   break
    # end
  end


  def self.get_share_data theurl

    require 'open-uri'
  
    # creates a new project
    #p params[:urls]
    #theurl = params[:urls]['address']
    # get the data for this one
    params = Hash.new
    
    params["delicious"] = delicious theurl
    params["twitter"] = twitter theurl
    params["stumbleupon"] = stumbleupon theurl
    params["facebook"] = facebook theurl
    params["updated"] = Time.now.to_s
  
    return params
  end
  
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



end
