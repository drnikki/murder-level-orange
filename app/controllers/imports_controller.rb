class ImportsController < ApplicationController


  SUBWAY_ENTRANCES = 'http://data.cityofnewyork.us/api/views/drex-xx56/rows.json'
  

  # this is the boss of the importers, for now.
  def boss
    require 'open-uri'

    aurl = SUBWAY_ENTRANCES
    opened = open(aurl).read
    imports = ActiveSupport::JSON.decode(opened)

    imports['data'].each do |record|
        p record
        p '------------------------------'

    end



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
  
  
  
  
  
  
  # WET Twitter data getter
  def self.twitter url
    aurl = TWITTER_URL.gsub("%%URL%%", url)
    opened = open(aurl).read
    jsonobj = ActiveSupport::JSON.decode(opened)
    # [{"url"=>"http://rapgenius.com", "normalized_url"=>"http://www.rapgenius.com/", "share_count"=>8525, "like_count"=>3995, "comment_count"=>5884, "total_count"=>18404, "click_count"=>3, "comments_fbid"=>10150415949665424, "commentsbox_count"=>0}]
    #p 'in twitter fn'
    #p jsonobj
    p jsonobj['count']
    return jsonobj['count']
  end



end
