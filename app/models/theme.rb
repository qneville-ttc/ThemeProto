class Theme < ActiveRecord::Base
  attr_accessible :theme_name, :theme_desc, :career_site_id

  has_many :templates, :dependent => :destroy
  belongs_to :career_site

 public
  	def init_blanks

      logger.debug("Oh hey man.  Guess it's working afterall...")
      tmp_assets = File.join(Rails.root,"app/assets/tmp")

      files = Dir.glob("#{Rails.root}/app/assets/tmp/**/*.liquid")
      
      files.each do |file|
        path = file
        template = self.templates.new
        template.permalink = path
        template.content   = File.read(path)
        template.save!
        logger.debug "record written -> #{path}" 
      end


  	end

end
