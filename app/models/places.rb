class Places
  include Mongoid::Document

  field :place_type, type: String
  field :name, type: String
  #@todo, make the relationships if project stays
  field :human_address, type: String
  field :description, type: String
  field :location, type: Array
  
 	# SUBWAY BULLSHIT
      #[1895, "1895", nil, nil, nil, 0, nil, nil, "1895", 
      #[nil, "40.73998433400004", "-73.98634300099991", nil, false, {"point"=>[-73.98634300099991, 40.73998433400004]}], 
      #{}"Park Ave & 23rd St At Se Corner (Uptown Only)", "http://www.mta.info/nyct/service/", "4-6-6 Express"]

  #WIFI JSON
  	# [21, "21", nil, nil, nil, 0, nil, nil, "21", [nil, "40.844490535000034", "-73.84660241899991", nil, false, {"point"=>[-73.84660241899991, 40.844490535000034]}], "McDonald's", "245", "1515 Williamsbridge Rd", "Bronx", "10461", " ", "Fee-based", "http://www.mcdonalds.com/wireless.html"]
  # bathrooms
  	# [443, "443", nil, nil, nil, 0, nil, nil, "443", [nil, "40.59544637400006", "-74.08151142499992", nil, false, {"rings"=>[[[-74.08151142499992, 40.59544637400006], [-74.08154427499994, 40.595498467000084], [-74.0814772999999, 40.595523007000054], [-74.08144444999994, 40.59547090800004], [-74.08151142499992, 40.59544637400006]]]}], "1295", "R063-BLG1304", "Ps 46 S Beach Hses Playground-Building", "NYCPARKS", "BUILDING", "X", "S", "R063", " ", -2209132800, "R063", "R063", "OLD TOWN SCHOOL", " ", " ", " ", "BATHROOM", "83.3901550649164846618077717721462249755859375", "434.5754083588941512061865068972110748291015625"]
  # laundromats
         #p record
      # # 11 NAME 13 ADDRESS
      # p record[10]
      # p record[13]
      # p record[15]
      # p record[17][1]
      # p record[17][2]
  # greenmarkets
#  [46, "46", nil, nil, nil, 0, nil, nil, "46", [nil, "40.61724073400006", "-74.03360756099994", nil, false, {"point"=>[-74.03360756099994, 40.61724073400006]}], "Bay Ridge", "Brooklyn", nil, "3rd Avenue & 95th Street"]
	#91 92 10 13

	# noise complaints
#	, [ 3647283, "ED8A0B8C-7F4A-4130-B8B9-9BEBABD68BB4", 3647283, 1330159901, "399949", 1331065332, "399949", null, "22758096", 
# "2012-02-22T00:00:00", "2012-02-22T00:00:00", "NYPD", "New York City Police Department", "Noise - Commercial", "Car/Truck Music", 
# "Store/Commercial", "10016", "593 1 AVENUE", "1 AVENUE", "EAST 33 STREET", "EAST 34 STREET", null, null, "ADDRESS", "NEW YORK", 
# null, "Precinct", "Closed", "2012-02-22T00:00:00", "2012-02-22T00:00:00", "06 MANHATTAN", "MANHATTAN", "991567", "210222", 
# "Unspecified", "MANHATTAN", "Unspecified", "Unspecified", "Unspecified", "Unspecified", "Unspecified", "Unspecified", 
# "Unspecified", "Unspecified", "Unspecified", "N", null, null, null, null, null, null, null, null, null, null, null, 
# "40.74368440120076", "-73.97359428768951", [ null, "40.74368440120076", "-73.97359428768951", null, false ] ]
# 60-1 60-2 


  FACEBOOK_URL      = 'http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls=%%URL%%&format=json'
  TWITTER_URL       = 'http://urls.api.twitter.com/1/urls/count.json?url=%%URL%%'
  REDDIT_URL        = 'http://buttons.reddit.com/button_info.json?url=%%URL%%'
  LINKEDIN_URL      = 'http://www.linkedin.com/cws/share-count?url=%%URL%%'
  DIGG_URL          = 'http://widgets.digg.com/buttons/count?url=%%URL%%'
  DELICIOUS_URL     = 'http://feeds.delicious.com/v2/json/urlinfo/data?url=%%URL%%'
  STUMBLEUPON_URL   = 'http://www.stumbleupon.com/services/1.01/badge.getinfo?url=%%URL%%'
  PINTEREST_URL     = 'http://api.pinterest.com/v1/urls/count.json?url=%%URL%%'

  # get the share data when a new one is being created
  def self.get_place_data theurl

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
  
  
  def self.subways
		opened = open(SUBWAY_ENTRANCES).read
		imports = ActiveSupport::JSON.decode(opened)
		# what's all this http://stackoverflow.com/questions/7820514/how-to-save-data-from-a-json-array-to-the-database-mongodb
		imports['data'].each do |record|
			#[1895, "1895", nil, nil, nil, 0, nil, nil, "1895", 
			#[nil, "40.73998433400004", "-73.98634300099991", nil, false, {"point"=>[-73.98634300099991, 40.73998433400004]}], 
			#{}"Park Ave & 23rd St At Se Corner (Uptown Only)", "http://www.mta.info/nyct/service/", "4-6-6 Express"]
      p record[10] # address
      p record[12] # description


      # lat and long for subways
      p record[9][1]
      p record[9][2]
		end
  end

  def self.wifi
  	#http://data.cityofnewyork.us/api/views/ehc4-fktp/rows.json
 




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

  # WET Facebook data getter
  def self.facebook url

    #aurl = 'http://api.ak.facebook.com/restserver.php?v=1.0&method=links.getStats&urls=http://rapgenius.com&format=json'
    aurl = FACEBOOK_URL.gsub("%%URL%%", url)
    opened = open(aurl).read
    jsonobj = ActiveSupport::JSON.decode(opened)
    # [{"url"=>"http://rapgenius.com", "normalized_url"=>"http://www.rapgenius.com/", "share_count"=>8525, "like_count"=>3995, "comment_count"=>5884, "total_count"=>18404, "click_count"=>3, "comments_fbid"=>10150415949665424, "commentsbox_count"=>0}]

    #p jsonobj
    p jsonobj[0]['share_count']
    p jsonobj[0]['like_count']
    p jsonobj[0]['comment_count']
    p jsonobj[0]['click_count']
    p jsonobj[0]['total_count']

    return jsonobj[0]['share_count']
  end

  # WET Stumbelupon data getter
  def self.stumbleupon url
    aurl = STUMBLEUPON_URL.gsub("%%URL%%", url)
    opened = open(aurl)
    jsonobj = ActiveSupport::JSON.decode(opened)
    p jsonobj['result']['views']
    return jsonobj['result']['views']
  end

  # and finally, WET AS SHIT delicious data getter
  def self.delicious url
    aurl = DELICIOUS_URL.gsub("%%URL%%", url)
    opened = open(aurl)
    jsonobj = ActiveSupport::JSON.decode(opened)
    p jsonobj[0]['total_posts']
    # @todo - if for zero when it's null.
    return jsonobj[0]['total_posts']
  end








end
