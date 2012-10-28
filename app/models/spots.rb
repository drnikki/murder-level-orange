class Spots
  include Mongoid::Document


  field :spot_type, type: String
  field :name, type: String
  #@todo, make the relationships if project stays
  field :human_address, type: String
  field :description, type: String
  field :location, type: Array
  
      #[1895, "1895", nil, nil, nil, 0, nil, nil, "1895", 
      #[nil, "40.73998433400004", "-73.98634300099991", nil, false, {"point"=>[-73.98634300099991, 40.73998433400004]}], 
      #{}"Park Ave & 23rd St At Se Corner (Uptown Only)", "http://www.mta.info/nyct/service/", "4-6-6 Express"]
end
