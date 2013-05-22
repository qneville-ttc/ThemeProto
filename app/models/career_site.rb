class CareerSite < ActiveRecord::Base
  attr_accessible :

  #has_many :themes

  after_initialize :default_values

  private
  	def default_values
  		self.current_theme_id = 0 if self.current_theme_id.nil?
  	end

end
