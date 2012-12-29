class Places
  include Mongoid::Document
  
  field :place_type,      type: String
  field :name,            type: String
  field :human_address,   type: String
  field :description,     type: String
  field :location,        type: Array    

  #todo, add index here.
  
end
