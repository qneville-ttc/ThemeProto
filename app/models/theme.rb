class Theme < ActiveRecord::Base
  attr_accessible :career_site_id, :theme_desc, :theme_filename, :theme_name
  has_many :templates
end
