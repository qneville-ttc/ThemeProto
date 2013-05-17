class Template < ActiveRecord::Base
  attr_accessible :career_site_id, :content, :permalink, :theme_id
  
  belongs_to :themes
  
end
