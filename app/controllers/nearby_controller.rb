class NearbyController < ApplicationController

  def index
    puts '*******************************'
    # sample location
    # Tribeca 40.714269 -74.005972 Sichuan Style Cucumber
    longz = 40.714269
    latz = -74.005972
    
    # 1. What's nearby you?
    # limits to 100. that's dumb'
    @places = Places.near(location: [longz, latz]).all.to_a
    
    # todo, buzsted.
    # get count of places
    location = Hash.new
    @places.each do |place|
       location[place.place_type] = 1 + location[place.place_type].to_i
       puts place.place_type    
    end
    
    location.each do |l|
      puts l
    end
    
    
    puts "T?HERE ARE THSI dddMAN?Y"
    puts @places.count
    
  end
  
  def view
    puts 'wtf'
  end
  
  # takes posted lat,long and goes and gets what's nearby.
  def lookup
    puts request
    
    puts '*******************************'
    # sample location
    # Tribeca 40.714269 -74.005972 Sichuan Style Cucumber
    longz = request['long']
    latz = request['lat']
    
    # 1. What's nearby you?
    # limits to 100. that's dumb'
    @places = Places.near(location: [longz, latz]).all.to_a
    
    # todo, buzsted.
    # get count of places
    location = Hash.new
    @places.each do |place|
       location[place.place_type] = 1 + location[place.place_type].to_i
       #puts place.place_type    
    end
    
    location.each do |l|
      puts l
    end
    
    
    puts "T?HERE ARE THSI dddMAN?Y"
    puts @places.count
    
    return :text => "trueish"
    #render :nothing => true
  end

end
