class Theme < ActiveRecord::Base
  
  has_many :templates, :dependent => :destroy
  
    

end
