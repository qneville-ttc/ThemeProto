class Theme < ActiveRecord::Base

  
  APP_ROOT = Rails.root.to_s
  
  attr_accessible :avatar
  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  
  has_many :templates
  
  validate :theme_name, presence: true
  validate :theme_desc, presence: true
  validate :theme_filename, presence: true
  
  
  
  

end
