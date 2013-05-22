class Template < ActiveRecord::Base
  attr_accessible :career_site_id, :content, :permalink, :theme_id
  
  belongs_to :theme

  

=begin
  # Finds a file based template by looking in path.
  class FileFinder
    def initialize(theme, ext, path, glob=nil)
      @ext   = ext.to_s
      @theme = theme
      @path  = path
      @glob  = glob || "**/*#{@ext}"
    end
    
    def [](name)
      file = File.join(@path, name) + @ext
      return Template.from_file(@theme, name, file) if paths.include?(file)
      nil
    end
    
    def paths
      Dir[File.join(@path, @glob)]
    end
    
    def all
      paths.map do |file|
        name = file.gsub(@path + "/", ""). # relativize
                    chomp(@ext) # remove extension
        
        Template.from_file(@theme, name, file)
      end.uniq.sort
    end
  end
  
  # Finds a db based template (CustomizedTemplate).
  class DBFinder
    def initialize(theme)
      @theme = theme

    end
    
    def [](name)
      CustomizedTemplate.for_theme(@theme).find_by_permalink(name).andand.to_template
    end
    
    def all
      CustomizedTemplate.for_theme(@theme).by_permalink.map(&:to_template)
    end
  end
  
  # ZipFinder
  # Searches temporarily uploaded zip file
  class ZipFinder

    def initialize(theme, ext, path, glob=nil)
      @ext   = ext.to_s
      @theme = theme
      @path  = path
      @glob  = glob || "**/*#{@ext}"
    end
    
    def [](name)
      file = File.join(@path, name) + @ext
      return Template.from_file(@theme, name, file) if paths.include?(file)
      nil
    end
    
    def paths
      Dir[File.join(@path, @glob)]
    end
    
    def all
      paths.map do |file|
        name = file.gsub(@path + "/", ""). # relativize
                    chomp(@ext) # remove extension
        
        Template.from_file(@theme, name, file)
      end.uniq.sort
    end
  end
  
  # Wraps a serie of template finders and acts like an Array.
  class Collection
    # Turn into a blank object
    instance_methods.each { |m| undef_method m unless m =~ /(^__|^nil\?$|^send$|proxy_|returning|^object_id$)/ }
    
    attr_reader :finders, :theme
    

    def initialize(theme,career_site_id)
    
      #File should be unzipped by now (By Theme Class)
      #Find in assets/tmp with current Career_site_id (:id.zip)
      #




      #use finders to loop through necessary files in folder.

      #for each file |f|, 
        #f.permalink = filepath
        #f.content = File.read(filepath)
        #if custom_theme,
          #career_site_id = @id
        #f.save

        #theme.save

        #remove zip file (assets/tmp/id.zip)
        #remove unzipped (assets/tmp/id)



    end

    #def initialize(theme)
      # Finders will be called in order, first one to return non-nil breaks
     # @finders = [
    #    FileFinder.new(theme, ".liquid", theme.templates_root),
      #  FileFinder.new(theme, "", theme.root, "{stylesheets,javascripts}/**"),
      #  FileFinder.new(theme, ".liquid", theme.shared_templates_root)
      #]
      
      #@finders.unshift DBFinder.new(theme) if theme.full_custom?
    #end
    
    # Find the first page for a permalink.
    # 1) In the db if present
    # 2) In the file under /themes/<name>/templates dir
    # 2) In the file under /themes/shared dir
    


    def find(permalink)
      template = nil
      @finders.detect { |f| template = f[permalink] }
      raise ActiveRecord::RecordNotFound, "Template not found: #{permalink}" unless template
      template
    end
    
    def starting_with(path)
      templates.select { |t| t.permalink.starts_with?(path) }
    end
    
    # Using method_missing magic here to lazy load all pages when calling Array methods on the collection.
    # 
    #  theme.templates.find("home") # won't load all the templates
    # 
    #  p = theme.templates    # not loaded yet
    #  p.collect(&:permalink) # loaded cause we called an Array method (collect)
    # 
    def method_missing(method, *args, &block)
      if [].respond_to?(method)
        templates.send(method, *args, &block)
      else
        super
      end
    end
    
    def respond_to?(method)
      super || [].respond_to?(method)
    end
    
    # HACK to prevent stack overflow in tests :/
    def inspect
      @templates.inspect
    end
    def to_yaml(*args)
      @templates.to_yaml(*args)
    end
    
    private
      def templates
        @templates ||= @finders.map(&:all).flatten.uniq.sort
      end
  end
  
  DEFAULT_MIME_TYPE = Mime::Type.lookup("text/html")
  
  # Some template like to be treated as if there were someone else.
  # One would be the alias of the other.
  # For example, if they share same widget regions.
  # 
  #   template =(alias) => original
  # 
  PERMALINK_ALIASES = { "jobs/archived" => "jobs", "jobs/search" => "jobs_search" }
  
  include Comparable
  
  attr_accessor :theme, :permalink, :filename, :customized_template
  attr_writer   :content
  
  delegate :career_site, :to => :theme
  
  def initialize(theme, permalink)
    @theme     = theme
    @permalink = permalink
    yield self if block_given?
  end
  
  def self.from_file(theme, permalink, filename)
    new(theme, permalink) do |t|
      t.filename = filename
    end
  end
  
  def content
    @content ||= (File.read(filename) if file_based?)
  end
  
  def static?
    file_based? && File.extname(filename) != ".liquid"
  end
  
  def file_based?
    !filename.blank?
  end
  
  def category
    dir = @permalink[/^(.*?)\//, 1]
    return dir if %w(stylesheets layouts javascripts).include?(dir)
    nil
  end

  def name
    @permalink.gsub(/^#{category}#{"/" if category}/, "")
  end
  
  def title
    name.gsub("/", " ").humanize.titleize
  end
  
  def ext
    File.extname(permalink)[1..-1]
  end
    
  def mime_type
    Mime::Type.lookup_by_extension(ext) || DEFAULT_MIME_TYPE
  end
  
  def content_type
    mime_type.to_s
  end
  
  def permalink_alias
    PERMALINK_ALIASES[permalink]
  end
  
  def to_liquid
    TemplateDrop.new(self)
  end
  
  def customized?
    @customized_template
  end
  
  def customized_template
    @customized_template || CustomizedTemplate.new(:career_site => @theme.career_site, :permalink => permalink, :content => content)
  end
  
  def widget_regions
    WidgetRegion.for_template(self)
  end
  
  def widget_layout
    career_site.widget_layouts.find_or_create_by_name(permalink)
  end
  
  def widget_region(name)
    career_site.widget_region(name, widget_layout.effective_name)
  end
  
  # Comparable stuff
  
  def <=>(other)
    return -1 unless Template === other
    permalink <=> other.permalink
  end
  
  def eql?(other)
    permalink.eql?(other.permalink)
  end
  
  def hash
    permalink.hash
  end
=end


end
